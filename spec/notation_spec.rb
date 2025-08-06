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
end
