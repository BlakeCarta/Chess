#require './lib/pgn_reader.rb'
require './lib/custom_data.rb'
#require './spec/support/spec_custom_data_helper.rb'
require './lib/notation.rb'

describe Notation do
  context '#get_special_character' do
    subject(:check_special_character) { described_class.new }
    it 'correctly identifies a check' do
      input = 'Bb5+'
      expect(subject.get_special_character(input)).to eq('+')
    end

    it 'marker not in last position should not be check' do
      input = '+Bb5'
      expect(subject.get_special_character(input)).to be false
    end

    it 'correctly identifies a checkmate' do
      input = 'Qh4#'
      expect(subject.get_special_character(input)).to eq('#')
    end

    it 'marker not in last position should not be checkmate' do
      input = '#Qh4'
      expect(subject.get_special_character(input)).to be false
    end

    it 'correctly identifies a capture' do
      input = 'Bxc6'
      expect(subject.get_special_character(input)).to eq('x')
    end

    it 'returns false for no capture' do
      input = 'Bc6'
      expect(subject.get_special_character(input)).to be false
    end

    it 'correctly identifies a promotion' do
      input = 'e7=Q'
      expect(subject.get_special_character(input)).to eq(['=', 'Q'])
    end

    it 'returns false for no promotion' do
      input = 'e8'
      expect(subject.get_special_character(input)).to be false
    end
  end

  subject(:check_destination) { described_class.new }
  context '#get_destination' do
    it 'gets the pawns destination' do
      input = CustomData.new(1, "e4")
      destination = 'e4'
      expect(subject.get_destination(input.white_move)).to eq(destination)
    end

    it 'gets the pawns destination when capturing' do
      input = CustomData.new(1, nil, "dxc6")
      destination = 'c6'
      expect(subject.get_destination(input.black_move)).to eq(destination)
    end

    it 'handles special characters at the end' do
      input = CustomData.new(1, "Bb5+")
      destination = 'b5'
      expect(subject.get_destination(input.white_move)).to eq(destination)
    end

    it 'returns nil for nil input' do
      input = nil
      expect(subject.get_destination(input)).to be nil
    end
  end

  subject(:convert_row_rank_alg_to_row_col) { described_class.new }
  context '#alg_to_row_col' do
    it 'converts h1 to 7,7' do
      input = 'h1'
      output = [7,7]
      expect(subject.alg_to_row_col(input)).to eq(output)
    end

    it 'converts a1 to 7,0' do
      input = 'a1'
      output = [7,0]
      expect(subject.alg_to_row_col(input)).to eq(output)
    end

    it 'converts d1 to 7,3' do
      input = 'd1'
      output = [7,3]
      expect(subject.alg_to_row_col(input)).to eq(output)
    end

    it 'converts d8 to 0,3' do
      input = 'd8'
      output = [0,3]
      expect(subject.alg_to_row_col(input)).to eq(output)
    end

    it 'converts c7 to 1,2' do
      input = 'c7'
      output = [1,2]
      expect(subject.alg_to_row_col(input)).to eq(output)
    end
  end


  subject(:convert_row_col_to_row_rank) { described_class.new }
  context '#row_col_to_alg' do
    it 'converts 7,7 to h1' do
      output = 'h1'
      input = [7,7]
      expect(subject.row_col_to_alg(input)).to eq(output)
    end

    it 'converts 7,0 to a1' do
      output = 'a1'
      input = [7,0]
      expect(subject.row_col_to_alg(input)).to eq(output)
    end

    it 'converts 7,3 to d1' do
      output = 'd1'
      input = [7,3]
      expect(subject.row_col_to_alg(input)).to eq(output)
    end

    it 'converts 0,3 to d8' do
      output = 'd8'
      input = [0,3]
      expect(subject.row_col_to_alg(input)).to eq(output)
    end

    it 'converts 1,2 to c7' do
      output = 'c7'
      input = [1,2]
      expect(subject.row_col_to_alg(input)).to eq(output)
    end
  end

end
