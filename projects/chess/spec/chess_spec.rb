require 'ostruct'

require './lib/game'

shared_examples 'a rook' do
  it 'can move up' do
    valid = valid_move?(board, s.i, s.j, s.i + 3, s.j)
    expect(valid).to be true
  end

  it 'can move down' do
    valid = valid_move?(board, s.i, s.j, s.i - 3, s.j)
    expect(valid).to be true
  end

  it 'can move to left' do
    valid = valid_move?(board, s.i, s.j, s.i, s.j - 3)
    expect(valid).to be true
  end

  it 'can move to right' do
    valid = valid_move?(board, s.i, s.j, s.i, s.j + 3)
    expect(valid).to be true
  end

  context 'when there is an enemy' do
    before { board[s.i + 2][s.j] = { piece: :pawn, color: :white } }

    it 'cannot jump over it' do
      valid = valid_move?(board, s.i, s.j, s.i + 3, s.j)
      expect(valid).to be false
    end
  end
end

shared_examples 'a bishop' do
  it 'can move diagonal up left' do
    valid = valid_move?(board, s.i, s.j, s.i - 3, s.j - 3)
    expect(valid).to be true
  end

  it 'can move diagonal down left' do
    valid = valid_move?(board, s.i, s.j, s.i + 3, s.j - 3)
    expect(valid).to be true
  end

  it 'can move diagonal up right' do
    valid = valid_move?(board, s.i, s.j, s.i - 3, s.j + 3)
    expect(valid).to be true
  end

  it 'can move diagonal down right' do
    valid = valid_move?(board, s.i, s.j, s.i + 3, s.j + 3)
    expect(valid).to be true
  end

  context 'when are units on path' do
    before do
      board[s.i + 1][s.j + 1] = { piece: :pawn, color: :white }
      board[s.i + 2][s.j + 2] = { piece: :pawn, color: :black }
    end

    it 'cannot jump' do
      valid = valid_move?(board, s.i, s.j, s.i + 3, s.j + 3)
      expect(valid).to be false
    end
  end
end

describe '#valid_move' do
  let(:board) { Array.new(FILES.count) { Array.new(RANKS.count, nil) } }

  context 'black pawn' do
    let(:s) { OpenStruct.new(i: 1, j: 0) }
    before { board[s.i][s.j] = { piece: :pawn, color: :black } }

    it 'can move down' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j)
      expect(valid).to be true
    end

    it 'cannot move up' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j)
      expect(valid).to be false
    end

    it 'cannot move diagonal' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j + 1)
      expect(valid).to be false
    end

    context 'when there is a target' do
      before { board[s.i + 1][s.j + 1] = { piece: :rook, color: :white } }

      it 'can attack diagonal' do
        valid = valid_move?(board, s.i, s.j, s.i + 1, s.j + 1)
        expect(valid).to be true
      end
    end

    context 'when first move' do
      it 'can move two squares' do
        valid = valid_move?(board, s.i, s.j, s.i + 2, s.j)
        expect(valid).to be true
      end
    end

    context 'when not first move' do
      let(:s) { OpenStruct.new(i: 2, j: 0) }
      before { board[s.i][s.j] = { piece: :pawn, color: :black } }

      it 'cannot move two squares' do
        valid = valid_move?(board, s.i, s.j, s.i + 2, s.j)
        expect(valid).to be false
      end
    end
  end

  context 'white pawn' do
    let(:s) { OpenStruct.new(i: 6, j: 0) }
    before { board[s.i][s.j] = { piece: :pawn, color: :white } }

    it 'can move up' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j)
      expect(valid).to be true
    end

    it 'cannot move down' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j)
      expect(valid).to be false
    end

    it 'cannot move diagonal' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j + 1)
      expect(valid).to be false
    end

    context 'when there is a target' do
      before { board[s.i - 1][s.j + 1] = { piece: :rook, color: :white } }

      it 'can attack diagonal' do
        valid = valid_move?(board, s.i, s.j, s.i - 1, s.j + 1)
        expect(valid).to be true
      end
    end

    context 'when first move' do
      it 'can move two squares' do
        valid = valid_move?(board, s.i, s.j, s.i - 1, s.j)
        expect(valid).to be true
      end
    end

    context 'when not first move' do
      let(:s) { OpenStruct.new(i: 5, j: 0) }
      before { board[s.i][s.j] = { piece: :pawn, color: :black } }

      it 'cannot move two squares' do
        valid = valid_move?(board, s.i, s.j, s.i - 2, s.j)
        expect(valid).to be false
      end
    end
  end

  context 'rook' do
    let(:s) { OpenStruct.new(i: 3, j: 3) }
    before { board[s.i][s.j] = { piece: :rook, color: :black } }

    it_behaves_like 'a rook'

    it 'cannot move diagonal' do
      valid = valid_move?(board, s.i, s.j, s.i + 3, s.j + 3)
      expect(valid).to be false
    end
  end

  context 'knight' do
    let(:s) { OpenStruct.new(i: 3, j: 3) }
    before { board[s.i][s.j] = { piece: :knight, color: :black } }

    it 'can move 2 up 1 left' do
      valid = valid_move?(board, s.i, s.j, s.i - 2, s.j - 1)
      expect(valid).to be true
    end

    it 'can move 2 up 1 right' do
      valid = valid_move?(board, s.i, s.j, s.i - 2, s.j + 1)
      expect(valid).to be true
    end

    it 'can move 2 down 1 left' do
      valid = valid_move?(board, s.i, s.j, s.i + 2, s.j - 1)
      expect(valid).to be true
    end

    it 'can move 2 down 1 right' do
      valid = valid_move?(board, s.i, s.j, s.i + 2, s.j + 1)
      expect(valid).to be true
    end

    it 'can move 2 left 1 up' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j - 2)
      expect(valid).to be true
    end

    it 'can move 2 left 1 down' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j - 2)
      expect(valid).to be true
    end

    it 'can move 2 right 1 up' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j + 2)
      expect(valid).to be true
    end

    it 'can move 2 right 1 down' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j + 2)
      expect(valid).to be true
    end

    it 'cannot move 1 up 1 left' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j - 1)
      expect(valid).to be false
    end

    it 'cannot move 2 down 2 right' do
      valid = valid_move?(board, s.i, s.j, s.i + 2, s.j + 2)
      expect(valid).to be false
    end

    context 'when there are units on path' do
      before do
        board[s.i + 1][s.j] = { piece: :pawn, color: :white }
        board[s.i + 1][s.j + 1] = { piece: :pawn, color: :black }
        board[s.i + 1][s.j + 2] = { piece: :pawn, color: :white }
      end

      it 'can jump' do
        valid = valid_move?(board, s.i, s.j, s.i + 1, s.j + 2)
        expect(valid).to be true
      end
    end
  end

  context 'bishop' do
    let(:s) { OpenStruct.new(i: 3, j: 3) }
    before { board[s.i][s.j] = { piece: :bishop, color: :black } }

    it_behaves_like 'a bishop'

    it 'cannot move vertically' do
      valid = valid_move?(board, s.i, s.j, s.i + 3, s.j)
      expect(valid).to be false
    end

    it 'cannot move horizontally' do
      valid = valid_move?(board, s.i, s.j, s.i, s.j + 3)
      expect(valid).to be false
    end
  end

  context 'queen' do
    let(:s) { OpenStruct.new(i: 3, j: 3) }
    before { board[s.i][s.j] = { piece: :queen, color: :black } }

    it_behaves_like 'a rook'
    it_behaves_like 'a bishop'
  end

  context 'king' do
    let(:s) { OpenStruct.new(i: 3, j: 3) }
    before { board[s.i][s.j] = { piece: :king, color: :black } }

    it 'can move 1 up' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j)
      expect(valid).to be true
    end

    it 'can move 1 down' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j)
      expect(valid).to be true
    end

    it 'can move 1 left' do
      valid = valid_move?(board, s.i, s.j, s.i, s.j - 1)
      expect(valid).to be true
    end

    it 'can move 1 right' do
      valid = valid_move?(board, s.i, s.j, s.i, s.j + 1)
      expect(valid).to be true
    end

    it 'can move 1 up left' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j - 1)
      expect(valid).to be true
    end

    it 'can move 1 up right' do
      valid = valid_move?(board, s.i, s.j, s.i - 1, s.j + 1)
      expect(valid).to be true
    end

    it 'can move 1 down left' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j - 1)
      expect(valid).to be true
    end

    it 'can move 1 down right' do
      valid = valid_move?(board, s.i, s.j, s.i + 1, s.j + 1)
      expect(valid).to be true
    end

    it 'cannot move 2 down 1 right' do
      valid = valid_move?(board, s.i, s.j, s.i + 2, s.j + 1)
      expect(valid).to be false
    end

    context 'queen' do
      before { board[s.i + 1][s.j + 1] = { piece: :queen, color: :white } }

      it 'can attack queen' do
        expect(valid_move?(board, s.i, s.j, s.i + 1, s.j + 1))
          .to be true
      end
    end
  end
end

describe '#check?' do
  let(:board) { Array.new(FILES.count) { Array.new(RANKS.count, nil) } }
  before { board[3][3] = { piece: :king, color: :black } }

  context 'pawn threatens king' do
    before { board[4][4] = { piece: :pawn, color: :white } }

    it 'is check' do
      expect(check?(board, :black)).to be true
    end
  end

  context 'pawn seems to threaten king but both are same color' do
    before { board[2][4] = { piece: :pawn, color: :black } }

    it 'is not check' do
      expect(check?(board, :black)).to be false
    end
  end
end
