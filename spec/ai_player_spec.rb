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

        allow(@white_pawn).to receive(:get_moves).and_return([[2, 0], [1, 0]])
        allow(@board_manager).to receive(:get_location).and_return(@white_pawn)

        expected = [1, 0]
        expected2 = [2, 0]
        random_piece = subject.get_random_piece
        expect(random_piece[0][0]).to eq(0)
        expect(random_piece[1]).to match_array(expected) | match_array(expected2)
      end
    end

    context 'Selects the only pawn out of mostly enemy pawns' do
      it 'selects the white pawn among the black pawns' do
        @board_manager.set_location([5, 5], @white_pawn)
        @board_manager.set_location([0, 1], @black_pawn)
        @board_manager.set_location([0, 2], @black_pawn)
        @board_manager.set_location([0, 3], @black_pawn)
        @board_manager.set_location([0, 4], @black_pawn)

        subject.board_manager_ref = @board_manager
        subject.color = 'white'

        allow(@white_pawn).to receive(:get_moves).and_return([[6, 5]])
        allow(@board_manager).to receive(:get_location).and_return(@white_pawn)
        expected = [6, 5]
        random_piece = subject.get_random_piece
        # check chosen piece
        pawn_pos = [5, 5]
        expect(random_piece[0]).to match_array(pawn_pos)
      end

      # the randomness of this test means any issues can be hidden on many runs
      # so loop this test many times to try and force an issue to show
      # 10 times was consistent enough to show the test failure
      10.times do
        it 'selects the black pawn among the white pawns' do
          pawn_pos = [6, 7]
          @board_manager.set_location(pawn_pos, @black_pawn)
          @board_manager.set_location([0, 1], @white_pawn)
          @board_manager.set_location([0, 2], @white_pawn)
          @board_manager.set_location([0, 3], @white_pawn)
          @board_manager.set_location([0, 4], @white_pawn)
          @board_manager.set_location([5, 2], @white_pawn)
          @board_manager.set_location([6, 3], @white_pawn)
          @board_manager.set_location([7, 4], @white_pawn)
          @board_manager.set_location([1, 3], @white_pawn)
          @board_manager.set_location([2, 4], @white_pawn)
          @board_manager.set_location([3, 2], @white_pawn)
          @board_manager.set_location([4, 3], @white_pawn)
          @board_manager.set_location([7, 6], @white_pawn)

          subject.board_manager_ref = @board_manager
          subject.color = 'black'

          allow(@black_pawn).to receive(:get_moves).and_return([[5, 7]])

          random_piece = subject.get_random_piece
          # check chosen piece

          expect(random_piece[0]).to match_array(pawn_pos)
        end
      end
    end

    context 'Can select a piece other than pawns' do
      it 'can select a bishop' do
        @board_manager.set_location([0, 6], @white_bishop)
        @board_manager.set_location([6, 1], @black_pawn)
        @board_manager.set_location([7, 2], @black_pawn)
        @board_manager.set_location([5, 3], @black_pawn)
        @board_manager.set_location([4, 4], @black_pawn)

        subject.board_manager_ref = @board_manager
        subject.color = 'white'

        allow(@white_bishop).to receive(:get_moves).with(@board_manager).and_return([[1, 7]])
        allow(@board_manager).to receive(:get_location).and_return('x')
        allow(@board_manager).to receive(:get_location).with([0, 6]).and_return(@white_bishop)
        allow(@board_manager).to receive(:get_location).with([6, 1]).and_return(@white_pawn)
        allow(@board_manager).to receive(:get_location).with([7, 2]).and_return(@white_pawn)
        allow(@board_manager).to receive(:get_location).with([5, 3]).and_return(@white_pawn)
        allow(@board_manager).to receive(:get_location).with([4, 4]).and_return(@white_pawn)

        random_piece = subject.get_random_piece
        # check chosen piece
        pawn_pos = [0, 6]
        expect(random_piece[0]).to match_array(pawn_pos)
      end
    end
  end

  describe '#get_furthest_forward' do
    before { @board_manager = Board_Manager.new }

    context 'only friendly pieces' do
      it 'selects the bishop' do
        @board_manager.set_location([3, 5], @white_bishop)
        @board_manager.set_location([1, 1], @white_pawn)

        subject.board_manager_ref = @board_manager
        subject.color = 'white'

        allow(@white_bishop).to receive(:get_moves).and_return([[5, 7], [4, 6]])
        allow(@board_manager).to receive(:get_location).and_return('x')
        allow(@board_manager).to receive(:get_location).with([3, 5]).and_return(@white_bishop)
        allow(@board_manager).to receive(:get_location).with([1, 1]).and_return(@white_pawn)

        random_piece = subject.get_furthest_forward
        # check chosen piece
        bishop_pos = [3, 5]
        expect(random_piece[0]).to match_array(bishop_pos)
      end
    end

    context 'mixed pieces' do
      before do
        @board_manager.set_location([6, 0], @white_pawn)
        @board_manager.set_location([5, 0], @white_rook)
        @board_manager.set_location([1, 5], @white_king)
        @board_manager.set_location([6, 2], @black_pawn)
        @board_manager.set_location([5, 3], @black_rook)

        allow(@white_pawn).to receive(:get_moves).and_return([[7, 0]])
        allow(@black_rook).to receive(:get_moves).and_return([[6, 3], [7, 3]])
        allow(@board_manager).to receive(:get_location).and_return('x')
        allow(@board_manager).to receive(:get_location).with([6, 0]).and_return(@white_pawn)
        allow(@board_manager).to receive(:get_location).with([5, 0]).and_return(@white_rook)
        allow(@board_manager).to receive(:get_location).with([1, 5]).and_return(@white_king)
        allow(@board_manager).to receive(:get_location).with([6, 2]).and_return(@black_rook)
        allow(@board_manager).to receive(:get_location).with([5, 3]).and_return(@black_rook)
      end

      it 'selects the friendly pawn' do
        subject.board_manager_ref = @board_manager
        subject.color = 'white'

        random_piece = subject.get_furthest_forward
        # check chosen piece
        pawn_pos = [6, 0]
        expect(random_piece[0]).to match_array(pawn_pos)
      end

      it 'black selects the friendly pawn' do
        subject.board_manager_ref = @board_manager
        subject.color = 'black'

        random_piece = subject.get_furthest_forward
        # check chosen piece
        rook_pos = [5, 3]
        expect(random_piece[0]).to match_array(rook_pos)
      end
    end
  end
end
