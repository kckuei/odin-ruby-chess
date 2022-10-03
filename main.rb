# frozen_string_literal: false

require_relative './lib/chess'

game = ChessGame.new
game.start

# # Promote test case
# Move this to rspec test case
# board = ChessBoard.new
# board.new_game
# board.force_move([6, 7], [0, 7])
# board.draw_board
# puts board.promote_any?
# ps = board.ponds_to_promote
# ps.each { |pond| puts pond }
# board.promote(ps[0])
# board.draw_board
