# frozen_string_literal: false

# Castle module containing castle methods.
module Castle
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
end
