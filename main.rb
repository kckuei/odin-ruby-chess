# frozen_string_literal: false

require_relative './lib/chess'

puts ChessPiece.new(1, :pond, :solid).to_s
puts ChessPiece.new(2, :pond, :solid).to_s

board = ChessBoard.new
board.draw_board

board.make_pieces
board.draw_board
