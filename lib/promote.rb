# frozen_string_literal: false

# Some methods for pond promotion.

# Checks if a piece should be promoted regardless of player.
# A pond promote when it reaches the edge of the board.
def promote?(piece)
  piece.key == :pond && piece.pos[0].include?(0) || piece.pos[0].include?(@rows - 1)
end

# Returns true if there are ponds to promote regardless of player.
def promote_any?
  @board.pieces.each do |piece|
    return true if promote?(piece)
  end
  false
end

# Retuns the ponds that require promotion regardless of player.
def ponds_to_promote
  @board.pieces.map([]) do |acc, piece|
    acc << piece if promote?(piece)
  end
  acc
end
