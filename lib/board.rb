# frozen_string_literal: false

require_relative './string'
require_relative './piece'

# ChessBoard class.
class ChessBoard
  attr_reader :board

  # Initializes a ChessBoard instance.
  def initialize
    @rows =  8
    @columns = 8
    @board = make_gameboard
  end

  # Initializes and returns an empty chess board.
  # The board is a nested dict, where '' denotes empty.
  def make_gameboard
    board = []
    @rows.times { board << Array.new(@columns, '') }
    @board = board
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