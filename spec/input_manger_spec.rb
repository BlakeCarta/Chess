require_relative '../lib/input_manger.rb'
describe Input_Manager do
  subject { Input_Manager }
  describe '#get_input' do
    it 'returns the default value' do
      target, current = subject.get_input
      expect([target, current]).to match_array([[3,0], [1,1]])
    end
  end
end