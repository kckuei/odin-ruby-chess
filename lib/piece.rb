# frozen_string_literal: false

require_relative './search'

# ChessPiece module containing common methods to all chess pieces.
#
# Seperates the more generic & common methods from class-specific
# chess pieces to keep their definitions DRY.
# The module will be included to class-specific definitions for
# Rook, Knight, Bishop, King, Queen, nad Pond.
# A mixin approach is used rather than direct class inheritance.
module ChessPiece
  # Returns a chess piece avatar given the piece name and style.
  # piece : symbol of the piece name
  # style : symbol of the style name
  def assign_avatar(piece, style)
    hash = {
      pond: { outline: '♙', solid: '♟' },
      knight: { outline: '♘', solid: '♞' },
      bishop: { outline: '♗', solid: '♝' },
      rook: { outline: '♖', solid: '♜' },
      queen: { outline: '♕', solid: '♛' },
      king: { outline: '♔', solid: '♚' }
    }
    hash[piece][style]
  end

  # Returns the avatar representation.
  # @player and @avatar are instance variables.
  def to_s
    case @player
    when 1 then @avatar.center(2, ' ').red
    when 2 then @avatar.center(2, ' ').blue
    end
  end

  # Returns the a symbol.
  # @key is an instance variable.
  def to_sym
    @key
  end

  # So that a chess piece instance renders correctly in Board#draw_tile.
  def empty?
    false
  end

  # Update tile position of the chess piece
  # tile : an array representing the tile position, e.g. [0, 0]
  # @pos is an instance variable.
  def update_position(tile)
    @pos = tile
  end

  def update_first_move
    @first_move = false
  end

  # Checks if a specified move is valid.
  # move : an array representing the next move/tile position, e.g. [0, 2]
  # valid_moves : a nested array representing all valid moves, e.g. [[0,2],[1,1]]
  # Returns a boolean.
  def valid_move?(move, valid_moves)
    coords = @board.hash_move(move)
    valid_moves.include?(coords)
  end

  # Pretty prints all the valid moves for the current position.
  # @board is an instance variable.
  def print_valid_moves(valid_moves)
    puts "Valid moves from #{@board.hash_point(@pos).yellow.bold} (#{@piece.to_s.yellow.bold}):"
    moves = valid_moves.map { |move| @board.hash_point(move) }.sort
    moves = moves.map do |move|
      pnt = @board.hash_move(move.to_sym)
      @board.board[pnt[0]][pnt[1]].empty? ? move.green.bold : move.red.bold
    end
    print moves.join(', ')
  end

  # Returns the valid moves using chess code formatting, for testing.
  def valid_moves_testing(valid_moves)
    moves = valid_moves.map { |move| @board.hash_point(move) }
    moves.sort.join(', ')
  end

  # Filters out tiles where a friendly piece currently sits.
  # moves : nested list of coordinates.
  # @board is an instance variable.
  def filter_combatant(moves)
    current = @board.board[@pos[0]][@pos[1]]
    moves.filter do |move|
      nxt = @board.board[move[0]][move[1]]
      nxt.empty? || '' || nxt.player != current.player
    end
  end

  # Filters out tiles residing outside the board.
  # moves : nested list of coordinates.
  # @board is an instance variable.
  def filter_inside_board(moves)
    moves.filter { |val| @board.inside?(val) }
  end

  # Filters out moves that more than 1 tile away.
  # moves : nested list of coordinates.
  # @pos is an instane variable.
  def filter_more_than_one_away(moves)
    x, y = @pos
    moves.filter do |move|
      xm, ym = move
      true if xm <= x + 1 && xm >= x - 1 && ym <= y + 1 && ym >= y - 1
    end
  end
end

# Pond class for representing the pond chess piece.
#
# A pond may move forward 1 tile, 2 squares only if it's the first
# move, or diaganolly 1 tile to attack a combatant.
class Pond
  attr_reader :player, :piece, :avatar, :pos, :key, :first_move

  include ChessPiece

  # Initializes a Pond instance.
  def initialize(player, board, position, key, style = :solid)
    @player = player
    @board = board
    @pos = position
    @key = key
    @first_move = true
    @piece = :pond
    @avatar = style == :solid ? '♟' : '♙'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    i, j = @pos
    moves = []
    case @player
    # If belongs to player 1 (bottom position, red default)
    when 1
      # It can move forward up to two tiles
      moves << [i - 1, j] if @board.inside?([i - 1, j]) && @board.board[i - 1][j].empty?
      moves << [i - 2, j] if @board.inside?([i - 2, j]) && @board.board[i - 2][j].empty?
      # But the pond may only move 1 tile if its not the first move
      moves = filter_more_than_one_away(moves) unless @first_move
      # Or attack diaganolly to the left or right 1 tile
      moves << [i - 1, j - 1] if @board.inside?([i - 1, j - 1]) && !@board.board[i - 1][j - 1].empty?
      moves << [i - 1, j + 1] if @board.inside?([i - 1, j + 1]) && !@board.board[i - 1][j + 1].empty?
    # If player 2 (top, blue default)
    when 2
      # It can move forward down to two tiles
      moves << [i + 1, j] if @board.inside?([i + 1, j]) && @board.board[i + 1][j].empty?
      moves << [i + 2, j] if @board.inside?([i + 2, j]) && @board.board[i + 2][j].empty?
      # But the pond may only move 1 tile if its not the first move
      moves = filter_more_than_one_away(moves) unless @first_move
      # Or attack diaganolly to the left or right 1 tile
      moves << [i + 1, j - 1] if @board.inside?([i + 1, j - 1]) && !@board.board[i + 1][j - 1].empty?
      moves << [i + 1, j + 1] if @board.inside?([i + 1, j + 1]) && !@board.board[i + 1][j + 1].empty?
    end

    filter_combatant(filter_inside_board(moves))
  end
end

# Knight class for representing the knight chess piece.
#
# A knight can move/attack in an L pattern relative to its position.
class Knight
  attr_reader :player, :piece, :avatar, :pos, :key, :first_move

  include ChessPiece

  # Initializes a Knight instance.
  def initialize(player, board, position, key, style = :solid)
    @player = player
    @board = board
    @pos = position
    @key = key
    @first_move = true
    @piece = :knight
    @avatar = style == :solid ? '♞' : '♘'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    relative_moves = [[2, -1], [2, 1], [-2, 1], [-2, -1],
                      [1, 2], [1, -2], [-1, 2], [-1, -2]]
    moves = []
    relative_moves.each do |dx_dy|
      moves << [@pos[0] + dx_dy[0], @pos[1] + dx_dy[1]]
    end
    filter_combatant(filter_inside_board(moves))
  end
end

# Bishop class for representing the Bishop chess piece.
#
# A bishop can move in any diaganol direction, and distance.
class Bishop
  attr_reader :player, :piece, :avatar, :pos, :key, :first_move

  include ChessPiece
  include DiagSearch

  # Initializes a Bishop instance.
  def initialize(player, board, position, key, style = :solid)
    @player = player
    @board = board
    @pos = position
    @key = key
    @first_move = true
    @piece = :bishop
    @avatar = style == :solid ? '♝' : '♗'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = search_moves_diag(self)
    filter_combatant(filter_inside_board(moves))
  end
end

# Rook class for representing the rook chess piece.
#
# A rook can move in any vertical or horziontal direction, and distance.
# A rook can castle with the adjacent king if it is both their first move
# and there are no pieces in-between.
class Rook
  attr_reader :player, :piece, :avatar, :pos, :key, :first_move

  include ChessPiece
  include OrthoSearch

  # Initializes a Rook instance.
  def initialize(player, board, position, key, style = :solid)
    @player = player
    @board = board
    @pos = position
    @key = key
    @first_move = true
    @piece = :rook
    @avatar = style == :solid ? '♜' : '♖'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = search_moves_ortho(self)
    filter_combatant(filter_inside_board(moves))
  end
end

# Queen class for representing the queen chess piece.
#
# A queen can move in any direction: horizontal, vertical,
# diaganol, and through any distance
class Queen
  attr_reader :player, :piece, :avatar, :pos, :key, :first_move

  include ChessPiece
  include OrthoSearch
  include DiagSearch

  # Initializes a Queen instance.
  def initialize(player, board, position, key, style = :solid)
    @player = player
    @board = board
    @pos = position
    @key = key
    @first_move = true
    @piece = :queen
    @avatar = style == :solid ? '♛' : '♕'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = search_moves_ortho(self)
    moves.concat(search_moves_diag(self))
    filter_combatant(filter_inside_board(moves))
  end
end

# King class for representing the king chess piece.
#
# A king can move/attack in any direction within a 1 tile distance.
# A king can castle with the adjacent rook if it is both their first move
# and there are no pieces in-between.
class King
  attr_reader :player, :piece, :avatar, :pos, :key, :first_move

  include ChessPiece
  include OrthoSearch
  include DiagSearch

  # Initializes a King instance.
  def initialize(player, board, position, key, style = :solid)
    @player = player
    @board = board
    @pos = position
    @key = key
    @first_move = true
    @piece = :king
    @avatar = style == :solid ? '♚' : '♔'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = search_moves_ortho(self)
    moves.concat(search_moves_diag(self))
    filter_more_than_one_away(filter_combatant(filter_inside_board(moves)))
  end
end
