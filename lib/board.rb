# frozen_string_literal: false

require_relative './string'
require_relative './piece'

# ChessBoard class.
class ChessBoard
  attr_reader :board, :hash

  # Initializes a ChessBoard instance.
  def initialize
    @rows =  8
    @columns = 8
    @board = make_gameboard
    @hash = make_tile_hashmap
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
  def make_tile_hashmap
    hash = {}
    ('a'..'h').each_with_index do |c, j|
      8.times do |i|
        hash[(c + i.to_s).to_sym] = [i, j]
      end
    end
    hash
  end

  # Initializes player 1 and 2 gameboard with ChessPieces.
  def make_pieces
    @columns.times { |i| @board[1][i] = ChessPiece.new(1, :pond, :solid) }
    [0, 7].each { |i| @board[0][i] = ChessPiece.new(1, :rook, :solid) }
    [1, 6].each { |i| @board[0][i] = ChessPiece.new(1, :knight, :solid) }
    [2, 5].each { |i| @board[0][i] = ChessPiece.new(1, :bishop, :solid) }
    @board[0][4] = ChessPiece.new(1, :queen, :solid)
    @board[0][3] = ChessPiece.new(1, :king, :solid)

    @columns.times { |i| @board[6][i] = ChessPiece.new(2, :pond, :solid) }
    [0, 7].each { |i| @board[7][i] = ChessPiece.new(2, :rook, :solid) }
    [1, 6].each { |i| @board[7][i] = ChessPiece.new(2, :knight, :solid) }
    [2, 5].each { |i| @board[7][i] = ChessPiece.new(2, :bishop, :solid) }
    @board[7][3] = ChessPiece.new(2, :queen, :solid)
    @board[7][4] = ChessPiece.new(2, :king, :solid)
  end

  # Forcefully moves a piece from one tile to another, overwriting any object if it exists.
  # Does not check if the move is valid for the piece.
  def force_move(from, to)
    return if from.empty? || to.empty? || from == to
    return unless inside?(from) && inside?(to)

    @board[to[0]][to[1]] = @board[from[0]][from[1]]
    @board[from[0]][from[1]] = ''
  end

  # Check if a point is inside the board
  def inside?(point)
    x, y = point
    x >= 0 && x < @columns && y >= 0 && y < @rows
  end

  def check?(player)
    # check for check condition
  end

  def checkmate?(player)
    # check for checkmate condition
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
end
