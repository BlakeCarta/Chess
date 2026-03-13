require_relative '../lib/ai_player'
require_relative '../lib/board/board_manager'

describe AiPlayer do
  subject { AiPlayer.new }

  describe '#in_check?' do
    before do
      @board_manager = Board_Manager.new
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

    it 'white king is in check' do
      @board_manager.set_location([0, 0], @white_king)
      @board_manager.set_location([2, 2], @black_queen)
      @board_manager.set_location([1, 0], @black_pawn)
      @board_manager.set_location([0, 1], @black_pawn)
      subject.board_manager_ref = @board_manager
      subject.color = 'white'

      # exact output should not matter in this case
      allow(@white_king).to receive(:get_moves).and_return([[1, 1]])
      allow(@black_queen).to receive(:get_moves).and_return([[0, 0], [1, 0], [0, 1]])
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
  end
end
