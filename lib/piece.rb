# frozen_string_literal: false

# ChessPiece class.
class ChessPiece
  # Initializes a ChessPiece instance.
  def initialize(player, piece, style = 'solid')
    @player = player
    @piece = piece
    @avatar = assign_avatar(piece, style)
  end

  # Assigns the chess piece avatar given the piece name and style.
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
  def to_s
    case @player
    when 1 then @avatar.center(2, ' ').red
    when 2 then @avatar.center(2, ' ').blue
    end
  end

  def empty?
    false
  end
end
