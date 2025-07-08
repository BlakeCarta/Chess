require './lib/custom_data.rb'
#require './spec/spec_custom_data_helper.rb'

describe CustomData do
  context '#equivalent_all_items_of' do
    subject(:data_one) { described_class.new(1, 'e4', 'e5') }
    subject(:data_two) { described_class.new(1, 'e4', 'e5') }
    it 'is true' do
      expect(data_one).to equivalent_all_items_of(data_two)
    end
  end
  
  context '#equivalent_all_items_of failure' do
    subject(:data_one) { described_class.new(1, 'e3', 'e5') } 
    subject(:data_two) { described_class.new(1, 'e5', 'e5') } #HERE
    it 'is false' do
      expect(data_one).not_to equivalent_all_items_of(data_two)
    end
  end
end
