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

  describe '#convert_posistion_to_row_col' do
    it 'returns 3,4 for e4' do
      input = 'e4'
      expected = [3, 4]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns nil for invalid input' do
      input = 'el'

      expect(subject.convert_posistion_to_row_col(input)).to be_nil
    end
  end
end
