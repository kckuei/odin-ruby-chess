# frozen_string_literal: false

# Computer module for computer component/AI methods.
# Methods will be mixedin with ChessGame class.
module Computer
  # Gets all moves for a player, regardless of safety.
  # Returns not just he move, but a nested array of moves:
  # [[piece, move, enemy? boolean, object at nxt tile]..]
  # player : symbol representing player, :p1 or :p2
  def all_moves(player)
    array = []
    @board.pieces[player].values.each do |piece|
      piece.find_next_valid_moves.each do |move|
        nxt = piece_at(@board.hash_point(move).to_sym)
        array << [piece, move, enemy?(piece, nxt), nxt]
      end
    end
    array
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
    i = rand(0..array.length - 1)
    loop do
      piece = array[i][0]
      move = array[i][1]
      break if @board.safe?(piece.pos, move)

      array.delete_at(i)
      i = rand(0..array.length - 1)
    end
    array[i]
  end

  # Gets moves that capture enemy pieces.
  def killing_moves(moves_arr)
    moves_arr.filter { |array| array[2] }
  end

  # Rank moves by some cost-benefit metric.
  # Ranking based on prirotiy: King > Queen > Knight > Rook > Bishop > Pond
  # moves_arr: nested array of moves of the format:
  #   [[piece, move, enemy? boolean, object at nxt tile]..]
  # return_from_to : boolean keyword argument.
  #   If true, returns only the from and to positions as a nested array, e.g.
  #   [ [[0,0],[0,1]], [[5,6],[7,1]], ... ]
  #   Otherwise, the output will be of the same format as the input, but ranked
  #   accoridng to the priority.
  def rank_moves(moves_arr, return_from_to: false)
    ranked = []
    from_to = []
    [King, Queen, Knight, Rook, Bishop, Pond, String].each do |type|
      moves_arr.each do |arr|
        opponent = arr[3]
        next unless opponent.instance_of?(type)

        ranked << arr
        from_to << [arr[0].pos, arr[1]]
        # puts arr[3].to_s
      end
    end
    return_from_to ? from_to : ranked
  end

  # Given a player symbol, evaluates and returns a computer input/choice,
  # even if the player is type human.
  #
  #
  #   Ponds - must advance forward.
  #         - prefer to jump 2
  #         - or prioritize safey
  #   Knight, Rook, Queen - can target any piece.
  #          - knight's travails algorithm is applicable/usable here
  #   Bishop - can only reach pieces that are on its same color
  #   King - should protect itself, stay out of harms way
  #
  # player_sym : symbol representing the player, e.g. :p1, :p2
  def eval_computer_move(player_sym)
    # Returns a single move randomly (naive approach)
    move_array = pick_random_move(player_sym)
    piece, move, flag, next_tile = move_array

    # Move the piece.
    point = piece.pos
    dest = move
    force_move(point, dest)

    # Log successful move.
    log_move(@current_player, piece,
             @board.hash_point(point), @board.hash_point(dest))

    # # Returns all possible moves, but ranked by target (should randomy sample from this)
    # arrays = all_moves(sym)
    # ranked = rank_moves(arrays)
    # # killing = killing_moves(arrays)
  end
end
