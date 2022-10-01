# frozen_string_literal: false

require './lib/chess'

describe Knight do
  describe '#find_next_valid_moves' do
    let(:game) { ChessGame.new }
    context 'when board is initialized' do
      it 'should return [[5, 2], [5, 0]] coords for knight at [7,1]' do
        game.setup
        knight = game.piece_at(:b7)
        expect(knight.find_next_valid_moves).to eq [[5, 2], [5, 0]]
      end
    end

    context 'when board is initialized and pieces moved' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
      end
      it 'should return [[7, 1], [3, 3], [3, 1], [6, 4], [4, 0]] for knight now at [5,2]' do
        knight = game.piece_at(:c5)
        expect(knight.find_next_valid_moves).to eq [[7, 1], [3, 3], [3, 1], [6, 4], [4, 0]]
      end
    end
  end

  describe '#print_valid_moves_testing' do
    let(:game) { ChessGame.new }
    context 'when board is initialized' do
      before do
        game.setup
      end
      it 'should return a5, c5 for knight at b7' do
        knight = game.piece_at(:b7)
        valid = knight.find_next_valid_moves
        game.draw_board
        expect(knight.valid_moves_testing(valid)).to eq 'a5, c5'
      end
    end

    context 'when board is initialized and pieces moved' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
      end
      it 'should return a4, b3, b7, d3, e6 for knight at c5' do
        knight = game.piece_at(:c5)
        valid = knight.find_next_valid_moves
        game.draw_board
        expect(knight.valid_moves_testing(valid)).to eq 'a4, b3, b7, d3, e6'
      end
    end
  end
end

describe Bishop do
  describe '#print_valid_moves_testing' do
    let(:game) { ChessGame.new }
    context 'when board is initialized' do
      before do
        game.setup
      end
      it 'should return nil' do
        bishop = game.piece_at(:f7)
        valid = bishop.find_next_valid_moves
        game.draw_board
        expect(bishop.valid_moves_testing(valid)).to be_empty
      end
    end

    context 'when board is initialized and pieces moved' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
      end
      it 'should return a4, b3, b7, d3, e6 for bishop at f7' do
        bishop = game.piece_at(:f7)
        valid = bishop.find_next_valid_moves
        game.draw_board
        expect(bishop.valid_moves_testing(valid)).to eq 'a2, b3, c4, d5, e6'
      end
    end
  end
end

describe King do
  describe '#print_valid_moves_testing' do
    let(:game) { ChessGame.new }
    context 'when board is initialized' do
      before do
        game.setup
      end
      it 'should return nil' do
        king = game.piece_at(:e7)
        valid = king.find_next_valid_moves
        game.draw_board
        expect(king.valid_moves_testing(valid)).to be_empty
      end
    end

    context 'when board is initialized and pieces moved' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
      end
      it 'should return e6 for king at e7' do
        king = game.piece_at(:e7)
        valid = king.find_next_valid_moves
        game.draw_board
        expect(king.valid_moves_testing(valid)).to eq 'e6'
      end
    end
  end
end

describe Queen do
  describe '#print_valid_moves_testing' do
    let(:game) { ChessGame.new }
    context 'when board is initialized' do
      before do
        game.setup
      end
      it 'should return nil' do
        queen = game.piece_at(:d7)
        valid = queen.find_next_valid_moves
        game.draw_board
        expect(queen.valid_moves_testing(valid)).to be_empty
      end
    end

    context 'when pieces moved and queen at d7' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
      end
      it 'should return e6' do
        queen = game.piece_at(:d7)
        valid = queen.find_next_valid_moves
        game.draw_board
        expect(queen.valid_moves_testing(valid)).to eq 'e6'
      end
    end

    context 'when pieces moved and queen at d3' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
        game.force_move('d7', 'd3')
      end
      it 'should return a3, b3, b5, c2, c3, c4, d1, d2, d4, d5, e2, e3, f1' do
        queen = game.piece_at(:d3)
        valid = queen.find_next_valid_moves
        game.draw_board
        expect(queen.valid_moves_testing(valid)).to eq 'a3, b3, b5, c2, c3, c4, d1, d2, d4, d5, e2, e3, f1'
      end
    end
  end
end

describe Pond do
  describe '#print_valid_moves_testing' do
    let(:game) { ChessGame.new }
    context 'when board is initialized' do
      before do
        game.setup
      end
      it 'should return g4, g5 for pond at g6' do
        pond_p2 = game.piece_at(:g6)
        valid = pond_p2.find_next_valid_moves
        game.draw_board
        expect(pond_p2.valid_moves_testing(valid)).to eq 'g4, g5'
      end
    end

    context 'when pond can move forward or attack diaganol to 1 element' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
        game.force_move('d7', 'd3')
        game.force_move('g1', 'g4')
      end
      it 'should return f5, g5 for pond at g4' do
        pond_p1 = game.piece_at(:g4)
        valid = pond_p1.find_next_valid_moves
        game.draw_board
        expect(pond_p1.valid_moves_testing(valid)).to eq 'f5, g5'
      end
    end
  end
end

describe ChessBoard do
  describe '#check?' do
    subject(:board) { described_class.new }
    let(:game) { ChessGame.new }
    context 'when the board is initialized with a new game' do
      it 'it should return false for player 1' do
        board.new_game
        board.draw_board
        expect(board.check?(:p1)).not_to be true
      end
      it 'it should return false for player 2' do
        board.new_game
        expect(board.check?(:p2)).to be false
      end
    end

    context 'when player 2 is checked' do
      before do
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
      end
      it 'should return true for player 2' do
        game.draw_board
        expect(game.board.check?(:p2)).to be true
      end
      it 'should return false for player 1' do
        expect(game.board.check?(:p1)).not_to be true
      end
    end
  end

  describe '#checkmate?' do
    subject(:game) { ChessGame.new }
    context 'when player 2 is checkmated' do
      before do
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
        game.force_move('c5', 'a4')
        game.force_move('e7', 'c7')
      end
      it 'should return true for player 2' do
        game.draw_board
        expect(game.board.checkmate?(:p2)).to be true
      end
      it 'should return false for player 1' do
        expect(game.board.checkmate?(:p1)).not_to be true
      end
    end
  end
end
