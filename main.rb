# frozen_string_literal: false

require_relative './lib/chess'

puts ChessPiece.new(1, :pond, :solid).to_s
puts ChessPiece.new(2, :pond, :solid).to_s

board = ChessBoard.new
board.draw_board

board.make_pieces
board.draw_board

game = ChessGame.new
game.intro_screen
game.draw_board

game.setup
game.draw_board

game.force_move([7, 1], [5, 2])
game.force_move([0, 1], [2, 2])
game.force_move([6, 4], [4, 4])
game.force_move('e1', 'e3')
game.force_move('g7', 'f5')
game.force_move('g0', 'f2')
game.draw_board

# Generate new classes for movement/attack patterns. E.g.,
#
# Each piece will have a copy of one of these classes based on its designation, and saved as an attribute.
# In addition, the PieceClass will need another readable attribute, first_move?, which returns true if it is the first move of the piece.
# Should have methods
#   find_valid moves - finds the next immediate valid moves of a given piece given a gameboard
#   translate_moves - translates the indice locations to valid chess moves, e.g. a0
#
#
# all pieces
# can move onto another piece only if opposing
# only if it doesn't put the king in check
# must remain inside the board
#
# pond
# can move forward
#   2 squares if first move (only if no oposing piece at the location)
#   else 1 square (only if no opposing piece at the location)
# diaganol if attacking
#
# knight
# can move/attack in L pattern relative to its position
#
# king
# can move/attack in any direction 1 tile
# can castle if it is the king and adjacent rooks first move and there are no piece in between
#
# bishop
# can move in any diaganol direction, and distance
#
# rook
# can move in any vertical or horziontal direction, and distance
#
# queen
# can move in any direction, horizontal, vertical, diaganol, and any distance
#

# begin/rescues, faily gracefully when invalid input

# Loop options:
# [1] Enter a move
# [2] List valid moves of a chess piece
# [3] Save game
# [4] Quit
