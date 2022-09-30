# frozen_string_literal: false

require_relative './lib/chess'

# puts ChessPiece.new(1, :pond, :solid).to_s
# puts ChessPiece.new(2, :pond, :solid).to_s

# board = ChessBoard.new
# board.draw_board

# board.make_pieces
# board.draw_board

game = ChessGame.new
game.intro_screen
game.draw_board

game.setup
game.draw_board

knight = game.piece_at(:b7)
puts knight
knight.print_valid_moves(knight.find_next_valid_moves)

game.force_move([7, 1], [5, 2])
game.force_move([0, 1], [2, 2])
game.force_move([6, 4], [4, 4])
game.force_move('e1', 'e3')
game.force_move('g7', 'f5')
game.force_move('g0', 'f2')
game.draw_board

knight.print_valid_moves(knight.find_next_valid_moves)

bishop = game.piece_at(:f7)
puts bishop
bishop.print_valid_moves(bishop.find_next_valid_moves)
