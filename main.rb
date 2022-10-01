# frozen_string_literal: false

require_relative './lib/chess'

# game = ChessGame.new
# game.intro_screen
# game.draw_board

# game.setup
# game.draw_board

# queen2 = game.piece_at(:d7)
# knight2 = game.piece_at(:b7)
# pond1 = game.piece_at(:g1)
# pond2 = game.piece_at(:g6)
# game.force_move([7, 1], [5, 2])
# game.force_move([0, 1], [2, 2])
# game.force_move([6, 4], [4, 4])
# game.force_move('e1', 'e3')
# game.force_move('g7', 'f5')
# game.force_move('g0', 'f2')
# game.force_move('d7', 'd3')
# game.force_move('g1', 'g4')
# game.draw_board
# queen2.print_valid_moves(queen2.find_next_valid_moves)
# knight2.print_valid_moves(knight2.find_next_valid_moves)
# pond1.print_valid_moves(pond1.find_next_valid_moves)
# pond2.print_valid_moves(pond2.find_next_valid_moves)

# game = ChessGame.new
# game.setup
# game.force_move([7, 1], [5, 2])
# game.force_move([0, 1], [2, 2])
# game.force_move([6, 4], [4, 4])
# game.force_move('e1', 'e3')
# game.force_move('g7', 'f5')
# game.force_move('g0', 'f2')
# game.force_move('d7', 'd3')
# game.force_move('g1', 'g4')
# game.force_move('e0', 'd7')
# game.draw_board
# puts "Player 2 check? #{game.board.check?(:p2)}"

# game.force_move('d7', 'c7')
# game.force_move('c7', 'a7')
# game.force_move('c5', 'a4')
# game.force_move('e7', 'c7')
# game.draw_board
# puts "Player 2 checkmate? #{game.board.checkmate?(:p2)}"

game = ChessGame.new
game.setup
game.force_move([7, 1], [5, 2])
game.force_move([0, 1], [2, 2])
game.force_move([6, 4], [4, 4])
game.force_move('e1', 'e3')
game.force_move('g7', 'f5')
game.force_move('g0', 'f2')
game.force_move('d7', 'd3')
game.force_move('g1', 'g4')
game.force_move('e0', 'd7')
game.force_move('d7', 'c7')
game.force_move('c7', 'a7')
game.force_move('c5', 'b7')
game.force_move('e7', 'c7')
game.draw_board
puts "Player 2 check? #{game.board.check?(:p2)}"
puts "Player 2 checkmate? #{game.board.checkmate?(:p2)}"
puts "Player 2 safe move the knight? #{game.board.safe?('b7', 'a5')}"

# game = ChessGame.new
# game.start
