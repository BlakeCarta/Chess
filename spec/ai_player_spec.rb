require_relative '../lib/ai_player'
require_relative '../lib/board/board_manager'

describe AiPlayer do
  subject { AiPlayer.new }

  before do
    # @board_manager = Board_Manager.new
    @black_pawn = instance_double('Piece', name: 'pawn', color: 'black')
    @black_rook = instance_double('Piece', name: 'rook', color: 'black')
    @black_knight = instance_double('Piece', name: 'knight', color: 'black')
    @black_bishop = instance_double('Piece', name: 'bishop', color: 'black')
    @black_queen = instance_double('Piece', name: 'queen', color: 'black')
    @black_king = instance_double('Piece', name: 'king', color: 'black')

    @white_pawn = instance_double('Piece', name: 'pawn', color: 'white')
    @white_rook = instance_double('Piece', name: 'rook', color: 'white')
    @white_knight = instance_double('Piece', name: 'knight', color: 'white')
    @white_bishop = instance_double('Piece', name: 'bishop', color: 'white')
    @white_queen = instance_double('Piece', name: 'queen', color: 'white')
    @white_king = instance_double('Piece', name: 'king', color: 'white')
  end

  describe '#in_check?' do
    before { @board_manager = Board_Manager.new }

    it 'white king is in check' do
      @board_manager.set_location([0, 0], @white_king)
      @board_manager.set_location([2, 2], @black_queen)
      @board_manager.set_location([1, 0], @black_pawn)
      @board_manager.set_location([0, 1], @black_pawn)
      subject.board_manager_ref = @board_manager
      subject.color = 'white'

      # exact output should not matter in this case
      allow(@white_king).to receive(:get_moves).and_return([[1, 1]])
      allow(@black_queen).to receive(:get_moves).and_return([[0, 0], [2, 0], [0, 2]])
      allow(@black_pawn).to receive(:get_moves).and_return([[0, 0]])

      expect(subject.in_check?).to be true
    end

    it 'white king is not in check' do
      @board_manager.set_location([0, 0], @white_king)
      @board_manager.set_location([7, 7], @black_king)
      subject.board_manager_ref = @board_manager
      subject.color = 'white'

      # exact output should not matter in this case
      allow(@white_king).to receive(:get_moves).and_return([[1, 1]])
      allow(@black_king).to receive(:get_moves).and_return([[6, 6]])

      expect(subject.in_check?).to be false
    end

    it 'black king is in check' do
      @board_manager.set_location([7, 7], @black_king)
      @board_manager.set_location([5, 5], @white_queen)
      @board_manager.set_location([6, 7], @white_pawn)
      @board_manager.set_location([7, 6], @white_pawn)
      subject.board_manager_ref = @board_manager
      subject.color = 'black'

      # exact output should not matter in this case
      allow(@black_king).to receive(:get_moves).and_return([[6, 7]])
      allow(@white_queen).to receive(:get_moves).and_return([[7, 7], [5, 7], [7, 5]])
      allow(@white_pawn).to receive(:get_moves).and_return([[7, 7]])

      expect(subject.in_check?).to be true
    end

    it 'black king is not in check' do
      @board_manager.set_location([0, 0], @white_king)
      @board_manager.set_location([7, 7], @black_king)
      subject.board_manager_ref = @board_manager
      subject.color = 'black'

      # exact output should not matter in this case
      allow(@white_king).to receive(:get_moves).and_return([[1, 1]])
      allow(@black_king).to receive(:get_moves).and_return([[6, 6]])

      expect(subject.in_check?).to be false
    end
  end

  describe '#get_out_of_check' do
    before { @board_manager = Board_Manager.new }

    # having context issues with references to other boards leaking in
    context 'white king at 3,3' do
      it 'white king can get out of check' do
        @board_manager.set_location([3, 3], @white_king)
        @board_manager.set_location([2, 2], @black_queen)

        subject.board_manager_ref = @board_manager
        subject.color = 'white'

        allow(@white_king).to receive(:get_moves).and_return([[2, 2], [4, 3]])
        allow(@black_queen).to receive(:get_moves).and_return([[0, 0], [0, 1], [1, 1], [2, 0], [0, 2], [2, 2], [3, 3]])
        # allow(@black_pawn).to receive(:get_moves).and_return([[0, 0]])
        allow(@board_manager).to receive(:get_threatend_squares).with('white').and_return([[0, 0], [0, 1], [1, 1],
                                                                                           [2, 0], [0, 2], [2, 2], [3, 3]])

        expected = [[3, 3], [2, 2]]
        expected_alt = [[3, 3], [4, 3]]
        expect(subject.get_out_of_check).to match_array(expected) | match_array(expected_alt)
      end
    end

    context 'white king at 0,0' do
      before { @board_manager = Board_Manager.new }

      it 'white king can get out of check' do
        @board_manager.set_location([0, 0], @white_king)
        @board_manager.set_location([2, 2], @black_queen)

        @board_manager.set_location([0, 1], @black_pawn)
        subject.board_manager_ref = @board_manager
        subject.color = 'white'

        allow(@board_manager).to receive(:get_location).and_return('x')
        allow(@board_manager).to receive(:get_location).with([0, 0]).and_return(@white_king)
        allow(@board_manager).to receive(:find_piece).with('white', 'king').and_return([0, 0])

        allow(@white_king).to receive(:get_moves).and_return([[1, 1], [1, 0]])
        allow(@black_queen).to receive(:get_moves).and_return([[0, 0], [0, 1], [1, 1], [2, 0], [0, 2]])
        allow(@black_pawn).to receive(:get_moves).and_return([[0, 0]])
        allow(@board_manager).to receive(:get_threatend_squares).with('white').and_return([[0, 0], [0, 1], [1, 1], [2, 0],
                                                                                           [0, 2]])

        expected = [[0, 0], [1, 0]]
        expect(subject.get_out_of_check).to match_array(expected)
      end
    end

    context 'white king at 0,5' do
      before { @board_manager = Board_Manager.new }

      it 'white king can get out of check' do
        # @board_manager = Board_Manager.new
        subject.board_manager_ref = @board_manager

        @board_manager.set_location([0, 5], @white_king)
        @board_manager.set_location([0, 3], @white_pawn)
        @board_manager.set_location([0, 6], @white_pawn)
        @board_manager.set_location([1, 5], @white_pawn)
        @board_manager.set_location([1, 4], @white_pawn)
        @board_manager.set_location([1, 6], @white_pawn)

        @board_manager.set_location([2, 5], @black_queen)

        # @board_manager.set_location([0, 1], @black_pawn)

        subject.color = 'white'

        allow(@board_manager).to receive(:get_location).and_return('x')
        allow(@board_manager).to receive(:get_location).with([0, 5]).and_return(@white_king)
        allow(@board_manager).to receive(:get_location).with([0, 3]).and_return(@white_pawn)

        allow(@white_king).to receive(:get_moves).and_return([[1, 5], [0, 4], [0, 6], [0, 3], [1, 5], [1, 4], [1, 6]])
        allow(@black_queen).to receive(:get_moves).and_return([[0, 5], [1, 5], [2, 5]])
        # the white pawn moves should be irrelevant as long as it returns something
        allow(@white_pawn).to receive(:get_moves).and_return([[1, 3]])
        allow(@board_manager).to receive(:get_threatend_squares).with('white').and_return([[0, 5], [1, 5], [2, 5]])

        expected = [[0, 5], [0, 4]]
        expect(subject.get_out_of_check).to match_array(expected)
      end
    end

    context 'white king at 0,5' do
      before { @board_manager = Board_Manager.new }

      it 'black king can get out of check' do
        subject.board_manager_ref = @board_manager

        @board_manager.set_location([7, 5], @black_king)
        @board_manager.set_location([7, 4], @white_pawn)
        @board_manager.set_location([7, 6], @white_pawn)
        @board_manager.set_location([6, 6], @white_pawn)
        # @board_manager.set_location([6, 4], @white_pawn)
        # @board_manager.set_location([1, 6], @white_pawn)

        @board_manager.set_location([5, 5], @white_queen)

        subject.color = 'black'

        allow(@board_manager).to receive(:get_location).and_return('x')
        allow(@board_manager).to receive(:get_location).with([7, 5]).and_return(@black_king)
        # allow(@board_manager).to receive(:get_location).with([0, 3]).and_return(@white_pawn)

        allow(@black_king).to receive(:get_moves).and_return([[6, 4]])
        allow(@white_queen).to receive(:get_moves).and_return([[7, 5], [6, 5]])

        allow(@white_pawn).to receive(:get_moves).and_return([[]])
        allow(@board_manager).to receive(:get_threatend_squares).with('black').and_return([[7, 5], [6, 5]])

        expected = [[7, 5], [6, 4]]
        expect(subject.get_out_of_check).to match_array(expected)
      end
    end
  end

  describe '#get_random_piece' do
    before { @board_manager = Board_Manager.new }

    context 'Selects a pawn out of only pawns' do
      it 'white pawns only' do
        @board_manager.set_location([0, 0], @white_pawn)
        @board_manager.set_location([0, 1], @white_pawn)
        @board_manager.set_location([0, 2], @white_pawn)
        @board_manager.set_location([0, 3], @white_pawn)
        @board_manager.set_location([0, 4], @white_pawn)

        subject.board_manager_ref = @board_manager
        subject.color = 'white'

        # exact moves should not matter
        allow(@white_pawn).to receive(:get_moves).and_return([[2, 0], [1, 0]])
        # allow(@board_manager).to receive(:get_threatend_squares).with('white').and_return([[0, 0], [0, 1], [1, 1],
        # [2, 0], [0, 2], [2, 2], [3, 3]])
        allow(@board_manager).to receive(:get_location).and_return(@white_pawn)

        expected = [1, 0]
        random_piece = subject.get_random_piece
        expect(random_piece[0][0]).to eq(0)
        expect(random_piece[1]).to match_array(expected)
      end
    end
  end

  describe '#get_furthest_forward' do
  end
end
