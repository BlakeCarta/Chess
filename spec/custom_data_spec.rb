require './lib/custom_data.rb'

describe CustomData do
  context '#<=>' do
    subject(:data_one) { described_class.new(1, 'e4', 'e5') }
    subject(:data_two) { described_class.new(1, 'e4', 'e5') }
    it 'Says different but identical objects are equal' do
      check = []
      check << data_one.turn_number == data_two.turn_number
      check << data_one.white_move == data_two.white_move
      check << data_one.black_move == data_two.black_move
      expect(check.all?).to be true 
    end
  end
end