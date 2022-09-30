# frozen_string_literal: false

require_relative './string'
require_relative './piece'
require 'set'

# ChessBoard class representing a chess board with chess pieces.
#
# Chess piece objects are instantiated and stored on the 8x8 chess board.
# The chess pieces store a pointer to the board to help them decide
# whether moves are valid by checking adjacent chess objects.
class ChessBoard
  attr_reader :rows, :columns, :board, :pieces, :code_hash, :point_hash

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
      row_p = 1
      row_v = 0
      col_q = 4
      col_k = 3
    # Player 2 (bottom position, blue default color)
    when 2
      player_sym = :p2
      player_id = 2
      row_p = 6
      row_v = 7
      col_q = 3
      col_k = 4
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
      q: [Queen, [row_v, col_q]],
      k: [King, [row_v, col_k]]
    }
    # Create a hash for the player
    @pieces[player_sym] = {}
    # Then populate it with the chess pieces using the creation hash
    create_hash.each do |sym, obj_tile|
      obj, loc = obj_tile
      @pieces[player_sym][sym] = obj.new(player_id, self, loc)
    end
  end

  # Forcefully moves a piece from one tile to another, overwriting any object if it exists.
  # Does not check if the move is valid for the piece.
  # Updates the position of the piece but not the first_move attribute.
  def force_move(start_tile, end_tile)
    return if start_tile.empty? || end_tile.empty? || start_tile == end_tile
    return unless inside?(start_tile) && inside?(end_tile)

    piece = @board[start_tile[0]][start_tile[1]]
    piece.update_position(end_tile)

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
  # player_sym : symbol representing the player, :p1 or :p2
  def check?(player_sym)
    # Gets the possible moves of the player opposing player_sym as a set.
    opposing_sym = player_sym == :p1 ? :p2 : :p1
    moves = Set.new
    @pieces[opposing_sym].each_value do |piece|
      piece.find_next_valid_moves.each { |move| moves.add(move) }
    end

    # Then checks in the king's position coincides with the set.
    king = @pieces[player_sym][:k]
    return true if moves.include?(king.pos)

    false
  end

  def checkmate?(player)
    # check for checkmate condition
    # if any opposing pieces valid moves contains the king position
    # AND
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

  def trade(player)
    # trade piece, if applicable
  end

  # Draw the board and pieces.
  def draw_board
    k = 0
    puts '  ╔════════════════╗'
    (0..@rows - 1).each do |i|
      print "#{i} ║"
      inc = i.even? ? 0 : 1
      (0..@columns - 1).each do |j|
        k += 1
        draw_tile(@board[i][j].to_s, k + inc)
        puts '║' if j == @columns - 1
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
  # E.g. :a0 => [0,0]
  # symbol : a symbol representing the chess code for a tile.
  def hash_move(symbol)
    raise 'Invalid code hash key.' if @code_hash[symbol].nil?

    @code_hash[symbol]
  end

  # Converts coordinates to chess code, or takes a string/list,
  # and returns a string of the chess code.
  # E.g. [7, 1] => 'b7'
  # E.g. '71' => 'b7'
  # coord : a string or array representing the chess tile coordinates
  def hash_point(coord)
    string = coord.join('') if coord.instance_of?(Array)
    raise 'Invalid point hash key.' if @point_hash[string].nil?

    @point_hash[string]
  end

  # Returns the chess object at the tile location.
  # tile : a symbol representing the tile at a particular location
  def piece_at(tile)
    i, j = hash_move(tile)
    @board[i][j]
  end
end
