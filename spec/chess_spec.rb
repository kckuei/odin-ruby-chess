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
        king = game.piece_at(:d7)
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
        king = game.piece_at(:d7)
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
        queen = game.piece_at(:e7)
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

    context 'when player 1 is checked' do
      before do
        game.setup
        game.force_move([7, 1], [5, 2])
        game.force_move([0, 1], [2, 2])
        game.force_move([6, 4], [4, 4])
        game.force_move('e1', 'e3')
        game.force_move('g7', 'f5')
        game.force_move('g0', 'f2')
        game.force_move('e7', 'd3')
        game.force_move('g1', 'g4')
        game.force_move('d0', 'd7')
      end
      it 'should return true for player 1' do
        game.draw_board
        expect(game.board.check?(:p1)).to be true
      end
      it 'should return false for player 2' do
        expect(game.board.check?(:p2)).not_to be true
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
        game.force_move('d0', 'c7')
        game.force_move('c7', 'a7')
        game.force_move('c5', 'a4')
        game.force_move('e7', 'c7')
      end
      it 'should return true for player 1' do
        game.draw_board
        expect(game.board.checkmate?(:p1)).to be true
      end
      it 'should return false for player 2' do
        expect(game.board.checkmate?(:p2)).not_to be true
      end
    end
  end

  describe '#safe?' do
    subject(:game) { ChessGame.new }
    context 'when player 2 moves a knight from b7 to a5' do
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
        game.force_move('d0', 'd7')
        game.force_move('d7', 'c7')
        game.force_move('c7', 'a7')
        game.force_move('c5', 'b7')
        game.force_move('e7', 'c7')
      end
      it 'should return false' do
        game.draw_board
        expect(game.board.safe?('b7', 'a5')).not_to be true
      end
    end
  end
end

describe ChessGame do
  subject(:game) { described_class.new }

  context 'checkmate #1: fool\'s mate' do
    before do
      game.setup
      game.force_move('f6', 'f5')
      game.force_move('e1', 'e3')
      game.force_move('g6', 'g4')
      game.force_move('d0', 'h4')
    end
    it 'should return true checkmate on player1' do
      game.draw_board
      expect(game.board.checkmate?(:p1)).to be true
    end
    it 'should return false checkmate on player2' do
      expect(game.board.checkmate?(:p2)).not_to be true
    end
  end

  context 'checkmate #2: reversed fool\'s mate' do
    before do
      game.setup
      game.force_move('e6', 'e4')
      game.force_move('f1', 'f2')
      game.force_move('d6', 'd4')
      game.force_move('g1', 'g3')
      game.force_move('d7', 'h3')
    end
    it 'should return true checkmate on player2' do
      game.draw_board
      expect(game.board.checkmate?(:p2)).to be true
    end
    it 'should return false checkmate on player1' do
      expect(game.board.checkmate?(:p1)).not_to be true
    end
  end

  context 'checkmate #3: grob\'s attack - fool\'s mate pattern' do
    before do
      game.setup
      game.force_move('g6', 'g4')
      game.force_move('e1', 'e3')
      game.force_move('f6', 'f4')
      game.force_move('d0', 'h4')
    end
    it 'should return true checkmate on player1' do
      game.draw_board
      expect(game.board.checkmate?(:p1)).to be true
    end
    it 'should return false checkmate on player2' do
      expect(game.board.checkmate?(:p2)).not_to be true
    end
  end

  context 'checkmate #4: dutch defense - fool\'s mate pattern' do
    before do
      game.setup
      game.force_move('d6', 'd4')
      game.force_move('f1', 'f3')
      game.force_move('c7', 'g3')
      game.force_move('h1', 'h2')
      game.force_move('g3', 'h4')
      game.force_move('g1', 'g3')
      game.force_move('e6', 'e4')
      game.force_move('g3', 'h4')
      game.force_move('d7', 'h3')
    end
    it 'should return true checkmate on player2' do
      game.draw_board
      expect(game.board.checkmate?(:p2)).to be true
    end
    it 'should return false checkmate on player1' do
      expect(game.board.checkmate?(:p1)).not_to be true
    end
  end

  context 'checkmate #5: bird\'s opening - fool\'s mate pattern' do
    before do
      game.setup
      game.force_move('f6', 'f4')
      game.force_move('e1', 'e3')
      game.force_move('f4', 'e3')
      game.force_move('d1', 'd2')
      game.force_move('e3', 'd2')
      game.force_move('f0', 'd2')
      game.force_move('b7', 'c5')
      game.force_move('d0', 'h4')
      game.force_move('g6', 'g5')
      game.force_move('h4', 'g5')
      game.force_move('h6', 'g5')
      game.force_move('d2', 'g5')
    end
    it 'should return true checkmate on player1' do
      game.draw_board
      expect(game.board.checkmate?(:p1)).to be true
    end
    it 'should return false checkmate on player2' do
      expect(game.board.checkmate?(:p2)).not_to be true
    end
  end

  context 'checkmate #6: Caro-kann Defense smothered mate' do
    before do
      game.setup
      game.force_move('e6', 'e4')
      game.force_move('c1', 'c2')
      game.force_move('d6', 'd4')
      game.force_move('d1', 'd3')
      game.force_move('b7', 'c5')
      game.force_move('d3', 'e4')
      game.force_move('c5', 'e4')
      game.force_move('b0', 'd1')
      game.force_move('d7', 'e6')
      game.force_move('g0', 'f2')
      game.force_move('e4', 'd2')
    end
    it 'should return true checkmate on player2' do
      game.draw_board
      expect(game.board.checkmate?(:p2)).to be true
    end
    it 'should return false checkmate on player1' do
      expect(game.board.checkmate?(:p1)).not_to be true
    end
  end

  context 'checkmate #7: Italian Game Smothered Mate' do
    before do
      game.setup
      game.force_move('e6', 'e4')
      game.force_move('e1', 'e3')
      game.force_move('g7', 'f5')
      game.force_move('b0', 'c2')
      game.force_move('f7', 'c4')
      game.force_move('c2', 'd4')
      game.force_move('f5', 'e3')
      game.force_move('d0', 'g3')
      game.force_move('e3', 'f1')
      game.force_move('g3', 'g6')
      game.force_move('h7', 'f7')
      game.force_move('g6', 'e4')
      game.force_move('c4', 'e6')
      game.force_move('d4', 'f5')
    end
    it 'should return true checkmate on player1' do
      game.draw_board
      expect(game.board.checkmate?(:p1)).to be true
    end
    it 'should return false checkmate on player2' do
      expect(game.board.checkmate?(:p2)).not_to be true
    end
  end

  context 'checkmate #8: Owen\'s Defense - Fool\'s Mate Pattern' do
    before do
      game.setup
      game.force_move('e6', 'e4')
      game.force_move('b1', 'b2')
      game.force_move('d6', 'd4')
      game.force_move('c0', 'b1')
      game.force_move('f7', 'd5')
      game.force_move('f1', 'f3')
      game.force_move('e4', 'f3')
      game.force_move('b1', 'g6')
      game.force_move('d7', 'h3')
      game.force_move('g1', 'g2')
      game.force_move('f3', 'g2')
      game.force_move('g0', 'f2')
      game.force_move('g2', 'h1')
      game.force_move('f2', 'h3')
      game.force_move('d5', 'g2')
    end
    it 'should return true checkmate on player2' do
      game.draw_board
      expect(game.board.checkmate?(:p2)).to be true
    end
    it 'should return false checkmate on player2' do
      expect(game.board.checkmate?(:p1)).not_to be true
    end
  end

  context 'checkmate #9: Englund Gambit Mate' do
    before do
      game.setup
      game.force_move('d6', 'd4')
      game.force_move('e1', 'e3')
      game.force_move('d4', 'e3')
      game.force_move('d0', 'e1')
      game.force_move('g7', 'f5')
      game.force_move('b0', 'c2')
      game.force_move('c7', 'f4')
      game.force_move('e1', 'b4')
      game.force_move('f4', 'd6')
      game.force_move('b4', 'b6')
      game.force_move('d6', 'c5')
      game.force_move('f0', 'b4')
      game.force_move('d7', 'd6')
      game.force_move('b4', 'c5')
      game.force_move('d6', 'c5')
      game.force_move('b6', 'c7')
    end
    it 'should return true checkmate on player1' do
      game.draw_board
      expect(game.board.checkmate?(:p1)).to be true
    end
    it 'should return false checkmate on player2' do
      expect(game.board.checkmate?(:p2)).not_to be true
    end
  end

  context 'checkmate #10: Budapest Defense Smothered Mate' do
    before do
      game.setup
      game.force_move('d6', 'd4')
      game.force_move('g0', 'f2')
      game.force_move('c6', 'c4')
      game.force_move('e1', 'e3')
      game.force_move('d4', 'e3')
      game.force_move('f2', 'g4')
      game.force_move('g7', 'f5')
      game.force_move('b0', 'c2')
      game.force_move('c7', 'f4')
      game.force_move('f0', 'b4')
      game.force_move('b7', 'd6')
      game.force_move('d0', 'e1')
      game.force_move('a6', 'a5')
      game.force_move('g4', 'e3')
      game.force_move('a5', 'b4')
      game.force_move('e3', 'd5')
    end
    it 'should return true checkmate on player1' do
      game.draw_board
      expect(game.board.checkmate?(:p1)).to be true
    end
    it 'should return false checkmate on player2' do
      expect(game.board.checkmate?(:p2)).not_to be true
    end
  end

  context 'checkmate ui test' do
    before do
      allow(game).to receive(:puts) # suppresses puts
      allow(game).to receive(:gets).and_return('1', 'f6', 'f5', 'e1', 'e3', 'g6', 'g4', 'd0', 'h4', '5')
    end
    xit 'should return checkmate on player1' do
      # game.start
      # expect(game.board.checkmate?(:p1)).to be false # Returns true when it should be false.
      # expect(game).to receive(:puts).with(a_string_including('Checkmate! Player 1 wins!')).at_least(2).times # Returns true when it should be false.
      # expect { game.start }.not_to output.to_stdout # Returns true when it should be false.
    end
  end
end

describe ChessBoard do
  describe '#promote_any?' do
    subject(:board) { described_class.new }

    context 'When a pond reaches the end of the board' do
      before do
        board.new_game
        board.force_move([6, 7], [0, 7])
      end
      it 'it should return true' do
        board.draw_board
        expect(board.promote_any?).to be true
      end
    end
  end

  describe '#ponds_to_promote?' do
    subject(:board) { described_class.new }

    context 'When a pond reaches the end of the board' do
      before do
        board.new_game
        board.force_move([6, 7], [0, 7])
      end
      it 'it should return that pond at the end' do
        pond = board.board[0][7]
        expect(board.ponds_to_promote[0]).to eql pond
      end
    end
  end

  describe '#promote?' do
    subject(:board) { described_class.new }

    context 'When a pond is promoted' do
      before do
        board.new_game
        board.force_move([6, 7], [0, 7])
        allow(board).to receive(:gets).and_return('queen')
      end
      it 'should return a different object than a pond' do
        before = board.ponds_to_promote[0]
        board.promote(before)
        after = board.board[0][7]
        board.draw_board
        expect(after).not_to eql before
      end
      it 'should replace the pond with a queen' do
        before = board.ponds_to_promote[0]
        board.promote(before)
        after = board.board[0][7]
        board.draw_board
        expect(after.piece).to eq :queen
      end
    end
  end
end

describe ChessBoard do
  describe '#castle?' do
    subject(:board) { described_class.new }

    context 'When player 1 can castle but not player 2' do
      before do
        board.new_game
        board.force_move([7, 6], [7, 1])
        board.force_move([7, 5], [7, 2])
      end
      it 'should return true for player 1' do
        board.draw_board
        expect(board.castle?(:p1)).to be true
      end
      it 'should return false for player 2' do
        expect(board.castle?(:p2)).not_to be true
      end
    end
  end

  describe '#castle' do
    subject(:board) { described_class.new }

    context 'When player 1 castles' do
      before do
        board.new_game
        board.force_move([7, 6], [7, 1])
        board.force_move([7, 5], [7, 2])
      end
      it 'should move the rook to f7' do
        board.draw_board
        rook = board.piece_at(:h7)
        board.castle(:p1)
        expect(board.piece_at(:f7)).to eql rook
        board.draw_board
      end
      it 'should move the king to g7' do
        king = board.piece_at(:e7)
        board.castle(:p1)
        expect(board.piece_at(:g7)).to eql king
      end
    end
  end
end
