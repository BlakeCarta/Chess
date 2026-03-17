require_relative '../lib/chess.rb'
describe Chess do
  subject { Chess.new }
  describe '#play_turn' do
    xit '*NOT IMPLEMENTED FULLY YET* does a turn correctly' do
      expect(subject.play_turn).to eq(57)
    end
  end
end