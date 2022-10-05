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
  # hard_castle : if true, updates the first_move flags on the pieces.
  def castle(player, hard_castle = false)
    return unless castle?(player)

    # Coerce from integer to symbol
    player = player == 1 ? :p1 : :p2 if player.instance_of?(Integer)

    # Since castling cannot capture combatant piece, and
    # movement locations must be empty, the @pieces hash is not modified.
    case player
    # If player 1 (top position)
    when :p1
      king = piece_at(:e7)
      rook = piece_at(:h7)
      @board[7][4] = ''
      @board[7][7] = ''
      @board[7][6] = king
      @board[7][5] = rook
      king.update_position([7, 6])
      rook.update_position([7, 5])
    # If player 2 (bottom position)
    when :p2
      king = piece_at(:e0)
      rook = piece_at(:h0)
      @board[0][4] = ''
      @board[0][7] = ''
      @board[0][6] = king
      @board[0][5] = rook
      king.update_position([0, 6])
      rook.update_position([0, 5])
    end
    # hard_castle == true is a permanent castle
    king.update_first_move if hard_castle
    rook.update_first_move if hard_castle
  end

  # Returns true if the piece being moved is a king or rook,
  # and castling is feasible.
  # nxt : next piece that is being moved to a new tile
  # sym : symbol representing the player, :p1, or :p2
  def include_castle?(nxt, sym)
    (nxt.piece == :king || nxt.piece == :rook) && castle?(sym)
  end

  # Undoes castling for a player, if applicable.
  # player : symbol representing player :p1, :p2
  #     or integer 1, 2 representing the player number
  def undo_castle(player)
    # Coerce from integer to symbol
    player = player == 1 ? :p1 : :p2 if player.instance_of?(Integer)

    # Since castling cannot capture combatant piece, and
    # movement locations must be empty, the @pieces hash is not modified,
    # nor does it need to be modified during the undo.
    case player
    when :p1
      king = piece_at(:g7)
      rook = piece_at(:f7)
      @board[7][6] = ''
      @board[7][5] = ''
      @board[7][4] = king
      @board[7][7] = rook
      king.update_position([7, 4])
      rook.update_position([7, 7])
    when :p2
      king = piece_at(:g0)
      rook = piece_at(:f0)
      @board[0][6] = ''
      @board[0][5] = ''
      @board[0][4] = king
      @board[0][7] = rook
      king.update_position([0, 4])
      rook.update_position([0, 7])
    end
  end

  # Checks if castling is safe move for a player.
  # player : symbol representing player :p1, :p2
  #     or integer 1, 2 representing the player number
  def castle_safe?(player)
    # Coerce from integer to symbol
    player = player == 1 ? :p1 : :p2 if player.instance_of?(Integer)

    # Exit if castling is not a valid move for player.
    return false unless castle?(player)

    # Proceed with a soft castle.
    # Soft castles do not update first_move flags, and can basically be undone.
    castle(player)

    # If castling result in an unsafe move, undo it, and return false.
    if check?(player)
      undo_castle(player)
      return false
    end
    # Otherwise, undo it, and return true.
    undo_castle(player)
    true
  end
end
