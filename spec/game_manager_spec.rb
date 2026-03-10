require_relative '../lib/game_manager'
describe GameManager do
  subject { GameManager.new }

  context 'Default' do
    describe '#initialize' do
      it 'sets up a Input Manager' do
        expect(subject.input_manager).not_to be_nil
      end

      it 'sets up a Board Manager' do
        expect(subject.board_manager).not_to be_nil
      end

      it 'sets up an AI player' do
        expect(subject.ai_player).not_to be_nil
      end
    end
  end
end
