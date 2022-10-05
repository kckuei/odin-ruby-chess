# frozen_string_literal: false

# Promote module containing methods related to pond promotion.
module Promote
  # Checks if a piece should be promoted regardless of player.
  # A pond promote when it reaches the edge of the board.
  def promote?(piece)
    piece.piece == :pond &&
      ((piece.pos[0].zero? && piece.player == 1) ||
        (piece.pos[0] == @rows - 1 && piece.player == 2))
  end

  # Returns true if there are ponds to promote regardless of player.
  def promote_any?
    all = @pieces[:p1].values + @pieces[:p2].values
    all.each do |piece|
      return true if promote?(piece)
    end
    false
  end

  # Retuns the ponds that require promotion regardless of player.
  def ponds_to_promote
    all = @pieces[:p1].values + @pieces[:p2].values
    all.filter { |piece| promote?(piece) }
  end

  # Promotes a piece and updates the hash pieces.
  # piece : chess piece object
  def promote(piece)
    # Get the player
    player = piece.player == 1 ? :p1 : :p2
    case player
    when :p1 then puts 'Player 1 Pond Promotion!'.red
    when :p2 then puts 'Player 2 Pond Promotion!'.blue
    end

    ## Consider moving into seperate function.
    ## Consider switching to number input for consistency.
    # Can't promote to a king or pond
    valid = Set.new(%w[knight bishop rook queen])
    # Prompt user and validate
    puts 'What would you like to promote your pond to?'.yellow
    puts "Choices: #{'queen'.bold}, #{'rook'.bold}, #{'knight'.bold}, or #{'bishop'.bold}".yellow
    input = gets.chomp.downcase
    loop do
      break if valid.include?(input)

      puts "Invalid input. Pick #{'queen'.bold}, #{'rook'.bold}, #{'knight'.bold}, or #{'bishop'.bold}.".magenta.italic
      input = gets.chomp.downcase
    end

    case input
    when 'knight' then promote_to_piece(piece, player, 'n')
    when 'bishop' then promote_to_piece(piece, player, 'b')
    when 'rook' then promote_to_piece(piece, player, 'r')
    when 'queen' then promote_to_piece(piece, player, 'q')
    end
  end

  # Promotes an individual piece given existing piece, player symbol, and
  # promotion letter.
  # piece : current/existing piece to promote
  # player : symbol representing player, :p1 or :p2
  # letter : single character representing the piece type to promote to
  #   'n' - knight
  #   'q' - queen
  #   'r' - rook
  #   'b' - bishop
  #   ...
  def promote_to_piece(piece, player, letter)
    obj_hash = { 'n' => Knight, 'b' => Bishop, 'q' => Queen, 'r' => Rook }
    obj = obj_hash[letter]
    # Instantiate a new piece.
    num = highest_index_of_piece(player, letter)
    new_piece = obj.new(piece.player, self, piece.pos, num + 1)
    # Update the board.
    @board[piece.pos[0]][piece.pos[1]] = new_piece
    # Update the piece hash.
    @pieces[player]["#{letter}#{num + 1}".to_sym] = new_piece
    @pieces[player].delete(piece.key)
  end

  # Gets the highest index/rank on a specific piece for a given player.
  # So that we can assign unique symbols/keys to the pieces hash.
  # player_sym : symbol representing the player, :p1 or :p2
  # piece_letter : single character representing the piece type
  #   'n' - knight
  #   'q' - queen
  #   'r' - rook
  #   'b' - bishop
  #   ...
  def highest_index_of_piece(player_sym, piece_letter)
    # Convert key symbols string
    keys = @pieces[player_sym].keys.map(&:to_s)
    # Keep only desired pieces
    filtered = keys.filter { |key| key.include?(piece_letter) }
    # Get the highest designation, considering also no pieces
    if filtered.empty?
      0
    else
      filtered.map { |key| key.delete(piece_letter).to_i }.max
    end
  end
end
