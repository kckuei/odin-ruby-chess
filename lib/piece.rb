# frozen_string_literal: false

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

  # Checks if a specified move is valid.
  # move : an array representing the next move/tile position, e.g. [0, 2]
  # valid_moves : a nested array representing all valid moves, e.g. [[0,2],[1,1]]
  # Returns a boolean.
  def valid_move?(move, valid_moves)
    coords = @board.hash_move(move)
    valid_moves.include?(coords)
  end

  # Prints all the valid moves for the current position.
  # @board is an instance variable.
  def print_valid_moves(valid_moves)
    puts "Valid moves from #{@board.hash_point(@pos)}:"
    moves = valid_moves.map { |move| @board.hash_point(move) }
    puts moves.sort.join(', ')
  end

  # Filters out tiles where a friendly piece currently sits.
  # moves is a nested list of coordinates.
  # @board is an instance variable.
  def filter_combatant(moves)
    obj = @board.board[@pos[0]][@pos[1]]
    moves.filter do |move|
      nxt = @board.board[move[0]][move[1]]
      nxt.empty? || nxt.player != obj.player
    end
  end

  # Filters out tiles residing outside the board.
  # moves is a nested list of coordinates.
  # @board is an instance variable.
  def filter_inside_board(moves)
    moves.filter { |val| @board.inside?(val) }
  end
end

# Pond class for representing the pond chess piece.
#
# A pond move forward 1 square, or 2 squares if it is the first
# move, or diaganolly if attacking.
class Pond
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece

  # Initializes a Pond instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :pond
    @avatar = style == :solid ? '♟' : '♙'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    # x, y = @position
    # get the sign based on player
    # player 1 (red, top)   - positive sign (move down)
    # player 2 (blue, bott) - negative sign (move up)
    # initialize moves = []
    #

    # basic move set is
    # [[0, sign],[-1, sign],[1, sign]]

    # extra move
    # moves << [x, y + sign * 2] if first_move?

    filter_friendly(filter_inside_board(moves))
  end
end

# Knight class for representing the knight chess piece.
#
# A knight can move/attack in an L pattern relative to its position.
class Knight
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece

  # Initializes a Knight instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
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
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece

  # Initializes a Bishop instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :bishop
    @avatar = style == :solid ? '♝' : '♗'
  end
end

# Rook class for representing the rook chess piece.
#
# A rook can move in any vertical or horziontal direction, and distance.
class Rook
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece

  # Initializes a Rook instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :rook
    @avatar = style == :solid ? '♜' : '♖'
  end
end

# King class for representing the king chess piece.
#
# A king can move/attack in any direction within a 1 tile distance.
# A king can castle if it is the king and adjacent rooks first move
# and there are no pieces in-between.
class King
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece

  # Initializes a King instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :king
    @avatar = style == :solid ? '♚' : '♔'
  end
end

# Queen class for representing the queen chess piece.
#
# A queen can move in any direction: horizontal, vertical,
# diaganol, and through any distance
class Queen
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece

  # Initializes a Queen instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :queen
    @avatar = style == :solid ? '♛' : '♕'
  end
end
