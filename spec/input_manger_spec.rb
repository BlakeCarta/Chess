require_relative '../lib/input_manger'
describe Input_Manager do
  subject { Input_Manager }

  describe '#get_input' do
    it 'returns the default value' do
      target, current = subject.get_input
      expect([target, current]).to contain_exactly([3, 0], [1, 1])
    end

    xit '*collect user input*' do
      # get row, column input 'e4'
      # convert to internal cordinates
      # use to select
      # show moves in similiar output format e5, f4, d3
      # allow another input to select another piece, select a move
    end
  end

  describe '#convert_row_col_to_posistion' do
    it 'returns e4 for 3,4' do
      input = [3, 4]
      expected = 'e4'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns a1 for 0,0' do
      input = [0, 0]
      expected = 'a1'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns h8 for 7,7' do
      input = [7, 7]
      expected = 'h8'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns h5 for 4,7' do
      input = [4, 7]
      expected = 'h5'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns nil for invalid input' do
      input = ['el']

      expect(subject.convert_row_col_to_posistion(input)).to be_nil
    end

    it 'returns nil for no input' do
      input = []

      expect(subject.convert_row_col_to_posistion(input)).to be_nil
    end

    it 'returns nil for gibberish' do
      input = [1, 'thebluefox']

      expect(subject.convert_row_col_to_posistion(input)).to be_nil
    end
  end

  describe '#convert_posistion_to_row_col' do
    it 'returns 3,4 for e4' do
      input = 'e4'
      expected = [3, 4]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns 0,0 for a1' do
      input = 'a1'
      expected = [0, 0]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns 7,7 for h8' do
      input = 'h8'
      expected = [7, 7]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns 4,7 for h5' do
      input = 'h5'
      expected = [4, 7]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns nil for invalid input' do
      input = 'el'

      expect(subject.convert_posistion_to_row_col(input)).to be_nil
    end

    it 'returns nil for no input' do
      input = ''

      expect(subject.convert_posistion_to_row_col(input)).to be_nil
    end

    it 'returns nil for gibberish' do
      input = 'thebluefox'

      expect(subject.convert_posistion_to_row_col(input)).to be_nil
    end
  end
end
