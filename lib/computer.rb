# frozen_string_literal: false

# Computer module for computer component/AI methods.
module Computer
  # Gets all moves for a player, regardless of safety.
  # Returns not just he move, but a nested array of moves:
  # [[piece, move, enemy? boolean, object at nxt tile]..]
  # player : symbol representing player, :p1 or :p2
  def all_moves(player)
    array = []
    @board.pieces[player].each do |piece|
      piece.find_next_valid_moves.each do |move|
        nxt = piece_at(hash_point(move).to_sym)
        array << [[piece, move, enemy?(piece, nxt), nxt]]
      end
    end
  end

  # Given two pieces, returns true if they belong to opposing players.
  # piece : piece representing object to be moved
  # nxt : object (piece or '') at the next tile
  def enemy?(piece, nxt)
    !nxt.empty? && piece.player != nxt.player
  end

  # Naively picks and returns the first safe move for a player.
  def pick_random_move(player)
    array = all_moves(player)
    loop do
      i = rand(0..array.length - 1)
      piece = array[i][0]
      move = array[i][1]
      break if @board.safe?(piece.pos, move)

      array.delete_at(i)
    end
    array[i]
  end

  # Gets moves that capture enemy pieces.
  def killing_moves(moves)
    moves.filter { |array| array[2] }
  end

  # Rank moves by some cost-benefit metric.
  # King > Queen > Knight > Rook > Bishop > Pond
  def rank_moves(moves)
    ranked = []
    [King, Queen, Knight, Rook, Bishop, Pond, String].each do |type|
      ranked << moves.filter { |array| array[0].instance_of?(type) }
    end
  end
end
