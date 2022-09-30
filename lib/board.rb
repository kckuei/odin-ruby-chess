# frozen_string_literal: false

require_relative './string'
require_relative './piece'

# ChessBoard class representing a chess board with chess pieces.
#
# Chess piece objects are instantiated and stored on the 8x8 chess board.
# The chess pieces store a pointer to the board to help them decide
# whether moves are valid by checking adjacent chess objects.
class ChessBoard
  attr_reader :rows, :columns, :board, :code_hash, :point_hash

  # Initializes a ChessBoard instance.
  def initialize
    @rows =  8
    @columns = 8
    @board = make_gameboard
    @code_hash, @point_hash = make_hashmaps
  end

  # Initializes and returns an empty chess board.
  # The board is a nested dict, where '' denotes empty.
  def make_gameboard
    board = []
    @rows.times { board << Array.new(@columns, '') }
    board
  end

  # Sets up a new game.
  def new_game
    @board = make_gameboard
    make_pieces
  end

  # Creates a hashmap of the tile code to index coordinates.
  # The keys use symbols, e.g., :a0 => [0][0], :f4 => [4][5].
  def make_hashmaps
    hash_to_point = {}
    hash_to_code = {}
    ('a'..'h').each_with_index do |c, j|
      8.times do |i|
        hash_to_point[(c + i.to_s).to_sym] = [i, j]
        hash_to_code["#{i}#{j}"] = (c + i.to_s)
      end
    end
    [hash_to_point, hash_to_code]
  end

  # Initializes player 1 and 2 gameboard with ChessPieces.
  def make_pieces
    @columns.times { |i| @board[1][i] = Pond.new(1, self, [1, i]) }
    [0, 7].each { |i| @board[0][i] = Rook.new(1, self, [0, i]) }
    [1, 6].each { |i| @board[0][i] = Knight.new(1, self, [0, i]) }
    [2, 5].each { |i| @board[0][i] = Bishop.new(1, self, [0, i]) }
    @board[0][4] = Queen.new(1, self, [0, 4])
    @board[0][3] = King.new(1, self, [0, 3])

    @columns.times { |i| @board[6][i] = Pond.new(2, self, [6, i]) }
    [0, 7].each { |i| @board[7][i] = Rook.new(2, self, [7, i]) }
    [1, 6].each { |i| @board[7][i] = Knight.new(2, self, [7, i]) }
    [2, 5].each { |i| @board[7][i] = Bishop.new(2, self, [7, i]) }
    @board[7][3] = Queen.new(2, self, [7, 3])
    @board[7][4] = King.new(2, self, [7, 4])
  end

  # Forcefully moves a piece from one tile to another, overwriting any object if it exists.
  # Does not check if the move is valid for the piece.
  # Updates the position of the piece but not the first_move attribute.
  def force_move(start_tile, end_tile)
    return if start_tile.empty? || end_tile.empty? || start_tile == end_tile
    return unless inside?(start_tile) && inside?(end_tile)

    piece = @board[start_tile[0]][start_tile[1]]
    piece.update_position(end_tile)

    @board[end_tile[0]][end_tile[1]] = piece
    @board[start_tile[0]][start_tile[1]] = ''
  end

  # Check if a point is inside the board
  # point : an array representing a point
  def inside?(point)
    return false if point.nil? || point.empty?

    x, y = point
    x >= 0 && x < @columns && y >= 0 && y < @rows
  end

  def check?(player)
    # check for check condition
    # if any opposing pieces valid moves contains the kings position.
  end

  def checkmate?(player)
    # check for checkmate condition
    # if any opposing pieces valid moves contains the king position
    # AND
  end

  def castle?(player)
    # castle, if feasible
  end

  def trade(player)
    # trade piece, if applicable
  end

  # Draw the board and pieces.
  def draw_board
    k = 0
    puts '  ╔════════════════╗'
    (0..@rows - 1).each do |i|
      print "#{i} ║"
      inc = i.even? ? 0 : 1
      (0..@columns - 1).each do |j|
        k += 1
        draw_tile(@board[i][j].to_s, k + inc)
        puts '║' if j == @columns - 1
      end
    end
    puts '  ╚════════════════╝'
    puts ' ' * 3 << %w[a b c d e f g h].join(' ')
  end

  # Draw tile.
  # Supports draw_board.
  def draw_tile(val, idx)
    val = val.empty? ? '' : val
    if idx.odd?
      print format(val, 'dark')
    else
      print format(val)
    end
  end

  # Adds consistent padding so board draws correctly.
  # Supports draw_board.
  def format(val, tile = '')
    tile == 'dark' ? val.to_s.center(2, ' ').bg_gray : val.to_s.center(2, ' ')
  end

  # Converts a chess code to a move, or takes a symbol,
  # returns an array of the coordinates.
  # E.g. :a0 => [0,0]
  # symbol : a symbol representing the chess code for a tile.
  def hash_move(symbol)
    raise 'Invalid code hash key.' if @code_hash[symbol].nil?

    @code_hash[symbol]
  end

  # Converts coordinates to chess code, or takes a string/list,
  # and returns a string of the chess code.
  # E.g. [7, 1] => 'b7'
  # E.g. '71' => 'b7'
  # coord : a string or array representing the chess tile coordinates
  def hash_point(coord)
    string = coord.join('') if coord.instance_of?(Array)
    raise 'Invalid point hash key.' if @point_hash[string].nil?

    @point_hash[string]
  end

  # Returns the chess object at the tile location.
  # tile : a symbol representing the tile at a particular location
  def piece_at(tile)
    i, j = @board.hash_move(tile)
    @board[i][j]
  end
end
