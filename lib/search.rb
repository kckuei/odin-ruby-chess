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
