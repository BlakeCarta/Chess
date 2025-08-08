require './lib/board'
require './lib/notation'

describe ChessBoard do
  context '#setup_board' do
    subject(:starting_board) { described_class.new }
    it 'sets the intial correct state' do
      desired_state = [['♜', '♞', '♝', '♛', '♚', '♝', '♞', '♜'],
                       ['♟', '♟', '♟', '♟', '♟', '♟', '♟', '♟'],
                       ['◻︎', '◼︎', '◻︎', '◼︎', '◻︎', '◼︎', '◻︎', '◼︎'],
                       ['◼︎', '◻︎', '◼︎', '◻︎', '◼︎', '◻︎', '◼︎', '◻︎'],
                       ['◻︎', '◼︎', '◻︎', '◼︎', '◻︎', '◼︎', '◻︎', '◼︎'],
                       ['◼︎', '◻︎', '◼︎', '◻︎', '◼︎', '◻︎', '◼︎', '◻︎'],
                       ['♙', '♙', '♙', '♙', '♙', '♙', '♙', '♙'],
                       ['♖', '♘', '♗', '♕', '♔', '♗', '♘', '♖']]
      expect(subject.setup_board).to eq(desired_state)
    end
  end

  context '#get_row_column' do
    subject(:starting_board) { described_class.new }
    it 'returns the white king when requested' do
      subject.setup_board
      target = [7,4]
      white_king = '♔'
      expect(subject.get_row_column(target)).to eq(white_king)
    end

    it 'returns the white king using chess notation' do
      subject.setup_board
      input = 'e1'
      #target = [7,4]
      white_king = '♔'
      notation_conversion = Notation.new
      row_col = notation_conversion.alg_to_row_col(input)
      expect(subject.get_row_column(row_col)).to eq(white_king)
    end

    it 'returns the black queen using chess notation' do
      subject.setup_board
      input = 'd8'
      #target = [0,3]
      black_queen = '♛'
      notation_conversion = Notation.new
      row_col = notation_conversion.alg_to_row_col(input)
      expect(subject.get_row_column(row_col)).to eq(black_queen)
    end
  end

  context '#set_row_column' do
    subject(:starting_board) { described_class.new }
    it 'returns the white king at g3 when requested' do
      subject.setup_board
      target = [6,3]
      white_king = '♔'
      subject.set_row_column(target, white_king)
      expect(subject.get_row_column(target)).to eq(white_king)
    end

    it 'returns the white king at f2 using chess notation' do
      subject.setup_board
      input = 'f2'
      #target = [5,2]
      white_king = '♔'
      notation_conversion = Notation.new
      row_col = notation_conversion.alg_to_row_col(input)
      subject.set_row_column(row_col, white_king)
      expect(subject.get_row_column(row_col)).to eq(white_king)
    end

    it 'returns the black queen at d6 using chess notation' do
      subject.setup_board
      input = 'd6'
      #target = [3,6]
      black_queen = '♛'
      notation_conversion = Notation.new
      row_col = notation_conversion.alg_to_row_col(input)
      subject.set_row_column(row_col, black_queen)
      expect(subject.get_row_column(row_col)).to eq(black_queen)
    end

    it 'returns the black rook at h2 from capture using chess notation' do
      subject.setup_board
      input = 'h2'
      #target = [7,2]
      black_rook = '♜'
      notation_conversion = Notation.new
      row_col = notation_conversion.alg_to_row_col(input)
      subject.set_row_column(row_col, black_rook)
      expect(subject.get_row_column(row_col)).to eq(black_rook)
    end
  end
end
