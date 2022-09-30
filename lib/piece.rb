# frozen_string_literal: false

# OrthoSearch module containing general methods for orthgonal next move
# search/identification.
#
# This modules will be included with chess pieces that can move orthgonally
# such as King, Queen, and Rook to help identify next valid moves.
# All methods accept the instance variable (self) as the input.
# Valid moves are identified as those empty spaces in a given direction,
# including the first combatant piece.
module OrthoSearch
  # Gets the orthogonal movements.
  def search_moves_ortho(piece)
    moves = []
    moves.concat(search_moves_up(piece))
    moves.concat(search_moves_down(piece))
    moves.concat(search_moves_left(piece))
    moves.concat(search_moves_right(piece))
    moves
  end

  # Search for next valid moves to the left relative to piece (self).
  def search_moves_left(piece)
    i, j = @pos
    moves = []
    k = j - 1
    while k >= 0
      nxt = @board.board[i][k]
      if nxt.empty?
        moves << [i, k]
      else
        moves << [i, k] if nxt.player != piece.player
        break
      end
      k -= 1
    end
    moves
  end

  # Search for next valid moves to the right relative to piece (self).
  def search_moves_right(piece)
    i, j = @pos
    moves = []
    k = j + 1
    while k < @board.columns
      nxt = @board.board[i][k]
      if nxt.empty?
        moves << [i, k]
      else
        moves << [i, k] if nxt.player != piece.player
        break
      end
      k += 1
    end
    moves
  end

  # Search for next valid moves in downward direction relative to piece (self).
  def search_moves_down(piece)
    i, j = @pos
    moves = []
    k = i + 1
    while k < @board.columns
      nxt = @board.board[k][j]
      if nxt.empty?
        moves << [k, j]
      else
        moves << [k, j] if nxt.player != piece.player
        break
      end
      k += 1
    end
    moves
  end

  # Search for next valid moves in upward direction relative to piece (self).
  def search_moves_up(piece)
    i, j = @pos
    moves = []
    k = i - 1
    while k >= 0
      nxt = @board.board[k][j]
      if nxt.empty?
        moves << [k, j]
      else
        moves << [k, j] if nxt.player != piece.player
        break
      end
      k -= 1
    end
    moves
  end
end

# DiagSearch module containing general methods for diaganol next move
# search/identification.
#
# This modules will be included with chess pieces that can move diaganolly
# such as King, Queen, and Bishop to help identify next valid moves.
# All methods accept the instance variable (self) as the input.
# Valid moves are identified as those empty spaces in a given direction,
# including the first combatant piece.
module DiagSearch
  # Gets the diaganol movements.
  def search_moves_diag(piece)
    moves = []
    moves.concat(search_moves_diag_NW(piece))
    moves.concat(search_moves_diag_SE(piece))
    moves.concat(search_moves_diag_SW(piece))
    moves.concat(search_moves_diag_NE(piece))
    moves
  end

  # Search for next valid moves in NW direction relative to piece (self).
  def search_moves_diag_NW(piece)
    i, j = @pos
    moves = []
    m = i - 1
    n = j - 1
    while m >= 0 && n >= 0
      nxt = @board.board[m][n]
      if nxt.empty?
        moves << [m, n]
      else
        moves << [m, n] if nxt.player != piece.player
        break
      end
      m -= 1
      n -= 1
    end
    moves
  end

  # Search for next valid moves in SE direction relative to piece (self).
  def search_moves_diag_SE(piece)
    i, j = @pos
    moves = []
    m = i + 1
    n = j + 1
    while m < @board.rows && n < @board.columns
      nxt = @board.board[m][n]
      if nxt.empty?
        moves << [m, n]
      else
        moves << [m, n] if nxt.player != piece.player
        break
      end
      m += 1
      n += 1
    end
    moves
  end

  # Search for next valid moves in SW direction relative to piece (self).
  def search_moves_diag_SW(piece)
    i, j = @pos
    moves = []
    m = i + 1
    n = j - 1
    while m < @board.rows && n >= 0
      nxt = @board.board[m][n]
      if nxt.empty?
        moves << [m, n]
      else
        moves << [m, n] if nxt.player != piece.player
        break
      end
      m += 1
      n -= 1
    end
    moves
  end

  # Search for next valid moves in NE direction relative to piece (self).
  def search_moves_diag_NE(piece)
    i, j = @pos
    moves = []
    m = i - 1
    n = j + 1
    while m >= 0 && n < @board.columns
      nxt = @board.board[m][n]
      if nxt.empty?
        moves << [m, n]
      else
        moves << [m, n] if nxt.player != piece.player
        break
      end
      m -= 1
      n += 1
    end
    moves
  end
end

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
    puts "Valid moves from #{@board.hash_point(@pos)} (#{@piece}):"
    moves = valid_moves.map { |move| @board.hash_point(move) }
    puts moves.sort.join(', ')
  end

  # Filters out tiles where a friendly piece currently sits.
  # moves : nested list of coordinates.
  # @board is an instance variable.
  def filter_combatant(moves)
    obj = @board.board[@pos[0]][@pos[1]]
    moves.filter do |move|
      nxt = @board.board[move[0]][move[1]]
      nxt.empty? || nxt.player != obj.player
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
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece
  include OrthoSearch
  include DiagSearch

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
    moves = []
    # If player 1 (red, top),
    #  result = use move_down but exclude enemy pieces
    #  if self.first_move?
    #     result = result + filter within 2 tiles
    #  end
    #  result.concat(use move_SW + filter within 1 tile)
    #  result.concat(use move_SE + filter within 1 tile)

    # If player 2 (blue, bottom),
    #  result = use move_up but exclude enemy pieces
    #  if self.move_up?
    #     result = result + filter within 2 tiles
    #  end
    #  result.concat(use move_NW + filter within 1 tile)
    #  result.concat(use move_NE + filter within 1 tile)

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
  include DiagSearch

  # Initializes a Bishop instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :bishop
    @avatar = style == :solid ? '♝' : '♗'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = []
    moves.concat(search_moves_diag(self))
    filter_combatant(filter_inside_board(moves))
  end
end

# Rook class for representing the rook chess piece.
#
# A rook can move in any vertical or horziontal direction, and distance.
# A rook can castle with the adjacent king if it is both their first move
# and there are no pieces in-between.
class Rook
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece
  include OrthoSearch

  # Initializes a Rook instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :rook
    @avatar = style == :solid ? '♜' : '♖'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = []
    moves.concat(search_moves_ortho(self))
    filter_combatant(filter_inside_board(moves))
  end
end

# Queen class for representing the queen chess piece.
#
# A queen can move in any direction: horizontal, vertical,
# diaganol, and through any distance
class Queen
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece
  include OrthoSearch
  include DiagSearch

  # Initializes a Queen instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :queen
    @avatar = style == :solid ? '♛' : '♕'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = []
    moves.concat(search_moves_ortho(self))
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
  attr_reader :player, :piece, :avatar, :pos, :first_move

  include ChessPiece
  include OrthoSearch
  include DiagSearch

  # Initializes a King instance.
  def initialize(player, board, position, style = :solid)
    @player = player
    @board = board
    @pos = position
    @first_move = true
    @piece = :king
    @avatar = style == :solid ? '♚' : '♔'
  end

  # Finds the next valid moves.
  def find_next_valid_moves
    moves = []
    moves.concat(search_moves_ortho(self))
    moves.concat(search_moves_diag(self))
    filter_more_than_one_away(filter_combatant(filter_inside_board(moves)))
  end
end
