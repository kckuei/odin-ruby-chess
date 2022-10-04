# frozen_string_literal: false

# Castle module containing castle methods.
module Castle
  # Checks if player can castle.
  # A player can castle if it is the king and adjacent rooks
  # first move, and there are not pieces in-between them.
  # player : symbol representing player :p1, :p2
  #     or integer 1, 2 representing the player number
  def castle?(player)
    # Coerce from integer to symbol
    player = player == 1 ? :p1 : :p2 if player.instance_of?(Integer)
    case player
    # If player 1 (top position)
    when :p1
      obj1 = piece_at(:e7)
      obj2 = piece_at(:h7)
      if !obj1.empty? && !obj2.empty? &&
         obj1.piece == :king && obj2.piece == :rook &&
         obj1.first_move && obj2.first_move &&
         piece_at(:f7).empty? && piece_at(:g7).empty?
        return true
      end
    # If player 2 (bottom position)
    when :p2
      obj1 = piece_at(:e0)
      obj2 = piece_at(:h0)
      if !obj1.empty? && !obj2.empty? &&
         obj1.piece == :king && obj2.piece == :rook &&
         obj1.first_move && obj2.first_move &&
         piece_at(:f0).empty? && piece_at(:g0).empty?
        return true
      end
    end
    false
  end

  # If the player can castle, does so.
  # A player can castle if it is the king and adjacent rooks
  # first move, and there are not pieces in-between them.
  # player : symbol representing player :p1, :p2
  #     or integer 1, 2 representing the player number
  def castle(player)
    return unless castle?(player)

    # Coerce from integer to symbol
    player = player == 1 ? :p1 : :p2 if player.instance_of?(Integer)
    case player
    # If player 1 (top position)
    when :p1
      king = piece_at(:e7)
      rook = piece_at(:h7)
      @board[king.pos[0]][king.pos[1]] = ''
      @board[rook.pos[0]][rook.pos[1]] = ''
      @board[7][6] = king
      @board[7][5] = rook
    # If player 2 (bottom position)
    when :p2
      king = piece_at(:e0)
      rook = piece_at(:h0)
      @board[king.pos[0]][king.pos[1]] = ''
      @board[rook.pos[0]][rook.pos[1]] = ''
      @board[0][6] = king
      @board[0][5] = rook
    end
  end
end
