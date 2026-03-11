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

    describe '#play_game' do
      xit '(placeholder) starts up a full game' do
        # placeholder to help mock out what this will look like
        # this should do something like
        # Display a start message
        ###### and be able to load or quit the game at this point
        # set the ai player as black
        # set the board up
        # start an input manager
        # start a player class up
        # start turn
        # then tell have the input manager get the player move
        # communicate that with the board to validate
        # if valid -> make move
        # get the ai player to make a move
        # print the board state after every action
        # ensure check/checkmate is handled
        # update/print out any score/pieces captured
        # show move history???
        # loop turn until checkmate
        # handle save/quit/load interupts

        # writing this out, this may be better in the init test area
        # but this will stay here for now
      end
    end

    describe '#start_message' do
      it 'returns a start message' do
        expect(subject.start_message).to eq('Welcome to chess, game will start shortly!')
      end
    end

    describe '#set_default_colors' do
      it 'sets player to white and ai to black' do
        subject.set_default_colors
        expect(subject.player.color).to eq('white')
        expect(subject.ai_player.color).to eq('black')
      end
    end

    describe '#set_board, #show_board' do
      it 'sets the pieces on the board' do
        subject.set_board
        expect(subject.show_board.all? { |item| item == 'x' }).to be false
      end
    end

    describe '#player_turn' do
      before do
        @input_double = class_double(Input_Manager)
        @board_double = instance_double(Board_Manager)
        @piece_double = instance_double(Piece)

        subject.input_manager = @input_double
        subject.board_manager = @board_double
      end

      it 'calls the move function for a valid move input' do
        expect(@board_double).to receive(:move_piece)

        allow(@input_double).to receive(:play_turn).and_return(['move', [0, 0], [0, 1]])
        allow(@board_double).to receive(:get_location).with([0, 0]).and_return(@piece_double)
        allow(@board_double).to receive(:move_piece).with([0, 0], [0, 1]).and_return(nil)
        allow(@piece_double).to receive(:get_moves).and_return([[0, 1]])

        subject.player_turn
      end

      it 'Does not calls the move function for a valid selct input' do
        expect(@board_double).not_to receive(:move_piece)

        allow(@input_double).to receive(:play_turn).and_return(['select', [0, 0]])
        allow(@board_double).to receive(:get_location).with([0, 0]).and_return(@piece_double)

        allow(@piece_double).to receive(:get_moves).and_return([[0, 1]])

        subject.player_turn
      end
    end
  end
end
