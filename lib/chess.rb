# frozen_string_literal: false

require_relative './intro'
require_relative './board'

# ChessGame class.
class ChessGame
  def initialize
    @intro = Intro.new
    @board = ChessBoard.new
    @log = Logger.new
  end

  def intro_screen
    puts @intro.to_s
  end

  def draw_board
    @board.draw_board
  end

  # Force moves a piece without consideration of whether it is a valid move.
  def force_move(from, to)
    from = from.instance_of?(String) ? @board.hash[from.to_sym] : from
    to = to.instance_of?(String) ? @board.hash[to.to_sym] : to
    @board.force_move(from, to)
  end

  def setup
    @board.make_pieces
  end

  def reset
    @board = ChessBoard.new
    @log = Logger.new
  end
end
