# frozen_string_literal: false

require_relative './string'
require_relative './piece'
require_relative './chaos'
require_relative './promote'
require 'set'

# ChessBoard class representing a chess board with chess pieces.
#
# Chess piece objects are instantiated and stored on the 8x8 chess board.
# The chess pieces store a pointer to the board to help them decide
# whether moves are valid by checking adjacent chess objects.
# Attributes:
#   @rows - An integer representing number of rows on board.
#   @columns - An integer representing number of columns on board.
#   @board - A nested array that is @rows x @columns in size, containing chess
#            objects or '' for empty spaces.
#   @pieces - A hash for chess pieces that are in play.
#             For example, @pieces[:p1][:k1] gets the player 1 knight-1.
#             Captured pieces are removed from the hash so that they are not
#             included in check/checkmate evaluations.
#   @code_hash - A hash for converting chess codes to coordinates
#   @point_hash - A hash for converting coordinates to chess codes
class ChessBoard
  attr_reader :rows, :columns, :board, :pieces, :code_hash, :point_hash

  include Chaos
  include Promote

  # Initializes a ChessBoard instance.
  def initialize
    @rows =  8
    @columns = 8
    @board = make_gameboard
    @pieces = {} # Becomes { p1: {}, p2: {}, ... }
    @code_hash, @point_hash = make_hashmaps
  end

  # Initializes and returns an empty chess board.
  # The board is a nested dict, where '' denotes empty.
  def make_gameboard
    board = []
    @rows.times { board << Array.new(@columns, '') }
    board
  end

  # Sets up for new game.
  def new_game
    @board = make_gameboard
    @pieces = {}
    setup_standard_game
  end

  # Creates a hashmap of the tile code to index coordinates.
  # The keys use symbols, e.g., :a0 => [0][0], :f4 => [4][5].
  def make_hashmaps
    hash_to_point = {}
    hash_to_code = {}
    ('a'..'h').each_with_index do |c, j|
      8.times do |i|
        hash_to_point[(c + i.to_s).to_sym] = [i, j]
        hash_to_code["#{i}#{j}"] = (c + i.to_s)
      end
    end
    [hash_to_point, hash_to_code]
  end

  # Sets up the standard chess game by initializing player pieces and
  # assigning them to the board.
  def setup_standard_game
    # Creates the pieces for player 1 and 2.
    [1, 2].each { |player| make_player_pieces_std(player) }

    # Assigns player 1 pieces to board.
    @pieces[:p1].each_value do |piece|
      i, j = piece.pos
      @board[i][j] = piece
    end

    # Assigns player 2 pieces to board.
    @pieces[:p2].each_value do |piece|
      i, j = piece.pos
      @board[i][j] = piece
    end
  end

  # Makes & saves player pieces to the @piece hash before they get assigned to the board.
  #
  # It should get called twice (once for each player) for the standard game. The importance of
  # this step is that later we will enumerate over @pieces for validating check & checkmate conditions.
  # player : an integer representing the player number, 1 or 2
  def make_player_pieces_std(player)
    case player
    # Player 1 (top position, red default color)
    when 1
      player_sym = :p1
      player_id = 1
      row_p = 6
      row_v = 7
    # Player 2 (bottom position, blue default color)
    when 2
      player_sym = :p2
      player_id = 2
      row_p = 1
      row_v = 0
    end
    # Defines creation schedule.
    create_hash = {
      p1: [Pond, [row_p, 0]],
      p2: [Pond, [row_p, 1]],
      p3: [Pond, [row_p, 2]],
      p4: [Pond, [row_p, 3]],
      p5: [Pond, [row_p, 4]],
      p6: [Pond, [row_p, 5]],
      p7: [Pond, [row_p, 6]],
      p8: [Pond, [row_p, 7]],
      r1: [Rook, [row_v, 0]],
      r2: [Rook, [row_v, 7]],
      n1: [Knight, [row_v, 1]],
      n2: [Knight, [row_v, 6]],
      b1: [Bishop, [row_v, 2]],
      b2: [Bishop, [row_v, 5]],
      q: [Queen, [row_v, 3]],
      k: [King, [row_v, 4]]
    }
    # Create a hash for the player
    @pieces[player_sym] = {}
    # Then populate it with the chess pieces using the creation hash
    create_hash.each do |sym, obj_tile|
      obj, loc = obj_tile
      @pieces[player_sym][sym] = obj.new(player_id, self, loc, sym)
    end
  end

  # Forcefully moves a piece from one tile to another, overwriting any
  # object if it exists.
  #
  # Does not check if the move is valid for the piece.
  # Updates the piece @pos and @first_move attributes.
  # If the ending location is occupied by another piece, it gets destroyed,
  # and the @pieces hash is updated to reflect this. This is important so
  # that check/checkmate only consider pieces on the board.
  #
  # start_tile: an array representing the starting coordinates
  # end_tile: an array representing the ending coordinates
  def force_move(start_tile, end_tile)
    return if start_tile.empty? || end_tile.empty? || start_tile == end_tile
    return unless inside?(start_tile) && inside?(end_tile)

    # Dereference/remove the piece at the end tile from the @pieces hash.
    piece_at_end = @board[end_tile[0]][end_tile[1]]
    unless piece_at_end.empty?
      player_sym = piece_at_end.player == 1 ? :p1 : :p2
      @pieces[player_sym].delete(piece_at_end.to_sym)
    end

    # Updates the piece @pos and @first_move attributes.
    piece = @board[start_tile[0]][start_tile[1]]
    piece.update_position(end_tile)
    piece.update_first_move

    # Updates the board.
    @board[end_tile[0]][end_tile[1]] = piece
    @board[start_tile[0]][start_tile[1]] = ''
  end

  # Check if a point is inside the board
  # point : an array representing a point
  def inside?(point)
    return false if point.nil? || point.empty?

    x, y = point
    x >= 0 && x < @columns && y >= 0 && y < @rows
  end

  # Checks if a player's king is checked.
  #
  # Validates the condition by enumerating over all opponent pieces and
  # forming a set of all their possible moves. The king is in danger if
  # it's position coincides with the set of possible opponent moves.
  # player : symbol representing the player, :p1 or :p2
  def check?(player)
    # Gets the possible moves of the opposing player as a set.
    opposing = player == :p1 ? :p2 : :p1
    set = Set.new
    @pieces[opposing].each_value do |piece|
      moves = piece.find_next_valid_moves
      moves.each { |m| set.add(m) }
    end

    # Then checks in the king's position coincides with the set.
    king = @pieces[player][:k]
    return true if set.include?(king.pos)

    false
  end

  # Checks if a player is checkmated.
  #
  # Assuming the player is checked, enumerates over all possible moves
  # of the player to determine if one of the moves can break the check
  # condition. Two major necessities in the implementation are:
  # 1. The piece attribute, @pos must be updated during the move so that
  # the instance method #find_next_valid_moves yields correct values,
  # since it uses @pos for making this determination.
  # 2. The board attribute, @pieces must be updated if a opposing piece
  # is capture (the key must be deleted from the opposing player hash),
  # since the hash is used for making the check? determination.
  # player : symbol representing the player, :p1 or :p2
  def checkmate?(player)
    # Check is a necessary condition of checkmate.
    return false unless check?(player)

    opposing = player == :p1 ? :p2 : :p1

    # Enumerates over all player pieces and valid moves.
    @pieces[player].each_value do |piece|
      moves = piece.find_next_valid_moves
      moves.each do |move|
        # Save pointers to objects at start and move.
        i, j = piece.pos
        temp_start = @board[i][j]
        temp_final = @board[move[0]][move[1]]

        # Save the start position.
        temp_pos_start = [i, j]

        # Temporarily, update position, and play the move.
        # If enemy piece is captured, temporarily remove it from opposing @pieces hash.
        temp_start.update_position(move)
        @board[move[0]][move[1]] = temp_start
        @board[i][j] = ''
        @pieces[opposing].delete(temp_final.key) unless temp_final.empty?

        # If player no longer in check, then there exists a viable move.
        unless check?(player)

          # Then undo the move and changes, and return false.
          temp_start.update_position(temp_pos_start)
          @board[i][j] = temp_start
          @board[move[0]][move[1]] = temp_final
          @pieces[opposing][temp_final.key] = temp_final unless temp_final.empty?
          return false
        end
        # Otherwise, undo the move and changes, and continue.
        temp_start.update_position(temp_pos_start)
        @board[i][j] = temp_start
        @board[move[0]][move[1]] = temp_final
        @pieces[opposing][temp_final.key] = temp_final unless temp_final.empty?
      end
    end
    true
  end

  # Checks if a move is safe, i.e., does not put the king in danger (check).
  #
  # start : a string or array representing the start chess tile coordinates
  # move : a string or array representingt the end chess tile coordinates
  # E.g. [7, 1] => 'b7'
  # E.g. '71' => 'b7'
  def safe?(start, move)
    # Converts start and move to consistent array format, e.g. [7, 1]
    start = start.instance_of?(String) ? hash_move(start.to_sym) : start
    move = move.instance_of?(String) ? hash_move(move.to_sym) : move

    return false unless inside?(start) && inside?(move)

    # Get the piece and player
    piece = piece_at(hash_point(start).to_sym)
    player = piece.player == 1 ? :p1 : :p2
    opposing = player == :p1 ? :p2 : :p1

    # Save pointers to objects at start and move.
    i, j = piece.pos
    temp_start = @board[i][j]
    temp_final = @board[move[0]][move[1]]

    # Save the start position.
    temp_pos_start = [i, j]

    # Temporarily, update position, and play the move.
    # If enemy piece is captured, temporarily remove it from opposing @pieces hash.
    temp_start.update_position(move)
    @board[move[0]][move[1]] = temp_start
    @board[i][j] = ''
    @pieces[opposing].delete(temp_final.key) unless temp_final.empty?

    # If player in check, it is not a safe move and puts king in jeapordy.
    if check?(player)

      # Then undo the move and changes, and return false.
      temp_start.update_position(temp_pos_start)
      @board[i][j] = temp_start
      @board[move[0]][move[1]] = temp_final
      @pieces[opposing][temp_final.key] = temp_final unless temp_final.empty?
      return false
    end
    # Otherwise, undo the move and changes, and continue.
    temp_start.update_position(temp_pos_start)
    @board[i][j] = temp_start
    @board[move[0]][move[1]] = temp_final
    @pieces[opposing][temp_final.key] = temp_final unless temp_final.empty?
    true
  end

  # Checks if player can castle.
  # A player can castle if it is the king and adjacent rooks
  # first move, and there are not pieces in-between them.
  # player : integer representing the player number
  def castle?(player)
    case player
    # If player 1 (top position)
    when 1
      obj1 = piece_at([0, 3]).piece
      obj2 = piece_at([0, 0]).piece
      if !obj1.empty? && !obj2.empty? &&
         obj1.piece == 'king' && obj2.piece == 'rook' &&
         obj1.first_move && obj2.first_move &&
         piece_at([0, 1]).empty? && piece_at([0, 2]).empty?
        return true
      end
    # If player 2 (bottom position)
    when 2
      obj1 = piece_at([7, 4]).piece
      obj2 = piece_at([7, 7]).piece
      if !obj1.empty? && !obj2.empty? &&
         obj1.piece == 'king' && obj2.piece == 'rook' &&
         obj1.first_move && obj2.first_move &&
         piece_at([7, 5]).empty? && piece_at([7, 6]).empty?
        return true
      end
    end
    false
  end

  # If the player can castle, does so.
  # A player can castle if it is the king and adjacent rooks
  # first move, and there are not pieces in-between them.
  # player : integer representing the player number
  def castle(player)
    return unless castle?(player)

    case player
    # If player 1 (top position)
    when 1
      king = piece_at([0, 3]).piece
      rook = piece_at([0, 0]).piece
      @board.board[0, 2] = king
      @board.board[0, 1] = rook
    # If player 2 (bottom position)
    when 2
      king = piece_at([7, 4]).piece
      rook = piece_at([7, 7]).piece
      @board.board[7, 6] = king
      @board.board[7, 5] = rook
    end
  end

  def promote_pawn(player)
    # promote a piece, if applicable
  end

  # Draw the board and pieces.
  def draw_board
    k = 0
    puts ' ' * 3 << %w[a b c d e f g h].join(' ')
    puts '  ╔════════════════╗'
    (0..@rows - 1).each do |i|
      print "#{i} ║"
      inc = i.even? ? 0 : 1
      (0..@columns - 1).each do |j|
        k += 1
        draw_tile(@board[i][j].to_s, k + inc)
        puts "║ #{i}" if j == @columns - 1
      end
    end
    puts '  ╚════════════════╝'
    puts ' ' * 3 << %w[a b c d e f g h].join(' ')
  end

  # Draw tile.
  # Supports draw_board.
  def draw_tile(val, idx)
    val = val.empty? ? '' : val
    if idx.odd?
      print format(val, 'dark')
    else
      print format(val)
    end
  end

  # Adds consistent padding so board draws correctly.
  # Supports draw_board.
  def format(val, tile = '')
    tile == 'dark' ? val.to_s.center(2, ' ').bg_gray : val.to_s.center(2, ' ')
  end

  # Converts a chess code to a move, or takes a symbol,
  # returns an array of the coordinates.
  # symbol : a symbol representing the chess code for a tile.
  # E.g. :a0 => [0,0]
  def hash_move(symbol)
    raise 'Invalid code hash key.' if @code_hash[symbol].nil?

    @code_hash[symbol]
  end

  # Converts coordinates to chess code, or takes a string/list,
  # and returns a string of the chess code.
  # coord : a string or array representing the chess tile coordinates
  # E.g. [7, 1] => 'b7'
  # E.g. '71' => 'b7'
  def hash_point(coord)
    string = coord.instance_of?(Array) ? coord.join('') : coord
    raise 'Invalid point hash key.' if @point_hash[string].nil?

    @point_hash[string]
  end

  # Returns the chess object at the tile location.
  # tile : a symbol representing the tile at a particular location
  # E.g. :a0 => piece
  def piece_at(tile)
    i, j = hash_move(tile)
    @board[i][j]
  end
end
