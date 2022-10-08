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

  # Gets all safe moves for a player.
  def all_safe_moves(player)
    array_moves = all_moves(player)
    array_moves.filter do |array|
      piece, move, _flag, _nxt = array
      @board.safe?(piece.pos, move)
    end
  end

  # Given two pieces, returns true if they belong to opposing players.
  # piece : piece representing object to be moved
  # nxt : object (piece or '') at the next tile
  def enemy?(piece, nxt)
    !nxt.empty? && piece.player != nxt.player
  end

  # Naively picks a random move from an array of moves.
  def pick_random_move(array)
    i = rand(0..array.length - 1)
    array[i]
  end

  # Filters for moves that capture enemy pieces.
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
  #   Pieces should weigh self-preservation versus value gained.
  #
  #   Ponds
  #     - must advance forward.
  #     - prefer to jump 2
  #     - or prioritize safety/coverage net
  #   Knight, Rook, Queen, Bishop
  #     - can target any piece.
  #     - knight's travails algorithm is applicable/usable here
  #     - prefer pieces of equal or higher value, otherwise attempt to preserve
  #     - bishops can only reach pieces that are on its same color
  #     - can evaluate shortest distance to any enemy piece, lord, or king
  #   King
  #     - stay out of harms way, but can be aggressive otherwise
  #
  # player_sym : symbol representing the player, e.g. :p1, :p2
  def eval_computer_move(player_sym)
    # Get all safe moves
    moves = all_safe_moves(player_sym)

    # Pick a strategy randomly
    method = rand(0..1)
    case method
    when 0
      # Returns a single move randomly (naive approach)
      piece, move, _flag, _next = pick_random_move(moves)
    when 1
      # Returns a ranked move (slightly less naive, but guessable)
      ranked = rank_moves(moves)
      piece, move, _flag, _next = ranked[0]
    end

    # Move the piece.
    point = piece.pos
    dest = move
    force_move(point, dest)

    # Log successful move.
    log_move(@current_player, piece,
             @board.hash_point(point), @board.hash_point(dest))
  end
end
