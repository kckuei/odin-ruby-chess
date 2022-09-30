# frozen_string_literal: false

require_relative './lib/chess'

# puts ChessPiece.new(1, :pond, :solid).to_s
# puts ChessPiece.new(2, :pond, :solid).to_s

# board = ChessBoard.new
# board.draw_board

# board.setup_standard_game
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

king = game.piece_at(:e7)
puts king
king.print_valid_moves(king.find_next_valid_moves)

queen = game.piece_at(:d7)
puts queen
game.force_move('d7', 'd3')
game.draw_board
queen.print_valid_moves(queen.find_next_valid_moves)

pond = game.piece_at(:g6)
puts pond
pond.print_valid_moves(pond.find_next_valid_moves)

pond2 = game.piece_at(:g1)
puts pond2
game.force_move('g1', 'g4')
game.draw_board
pond2.print_valid_moves(pond2.find_next_valid_moves)

# game.board.make_player_pieces_std(1)
# game.board.make_player_pieces_std(2)
# game.board.pieces[:p1].each { |key, value| puts "#{key}:#{value}" }
# game.board.pieces[:p2].each { |key, value| puts "#{key}:#{value}" }

puts game.board.check?(:p1)
puts game.board.check?(:p2)
game.force_move('e0', 'd7')
game.draw_board
puts game.board.check?(:p1)
puts game.board.check?(:p2)
