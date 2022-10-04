# frozen_string_literal: false

require_relative './lib/chess'

# game = ChessGame.new
# game.start

board = ChessBoard.new
board.new_game
board.force_move([7, 6], [7, 1])
board.force_move([7, 5], [7, 2])
board.draw_board
puts board.castle?(:p1)
puts board.castle?(:p2)
board.force_move([0, 6], [0, 1])
board.force_move([0, 5], [0, 2])
board.draw_board
puts board.castle?(:p1)
puts board.castle?(:p2)
board.castle(:p1)
board.castle(:p2)
board.draw_board
