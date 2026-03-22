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

    describe '#play_round' do
      context 'default board start' do
        it 'moves 1 white & 1 black piece' do
          subject.default_start

          @input_double = class_double(Input_Manager)
          allow(@input_double).to receive(:play_turn).and_return(['move', [1, 0], [2, 0]])
          subject.input_manager = @input_double
          subject.play_round
          board = subject.show_board

          test = [board[2], board[3]].flatten.map { |each| each.is_a?(String) }.any?(false)
          black_test = [board[4], board[5]].flatten.map { |each| each.is_a?(String) }.any?(false)
          # a white piece is in row 3/4
          expect(test).to be true
          expect(black_test).to be true
        end

        it 'can play two rounds' do
          subject.default_start

          @input_double = class_double(Input_Manager)
          allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]], ['move', [3, 3], [4, 3]])
          subject.input_manager = @input_double
          subject.play_round
          subject.play_round
          board = subject.show_board

          expect(board[4][3].is_a?(String)).to be false
        end

        context 'Check/Checkmate tests' do
          it 'can detect a check' do
            @ai_double = instance_double(AiPlayer)
            @input_double = class_double(Input_Manager)

            subject.ai_player = @ai_double
            subject.input_manager = @input_double

            allow(@ai_double).to receive(:color=).with('black')
            allow(@ai_double).to receive(:color).and_return('black')

            # d2 -> d4 w
            # e7 -> e5 b
            # h2 -> h4 w
            # f8 -> b4 b - check
            # c1 -> d2 w - break check
            # ['move', [2, 0], [3, 1]]
            allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]],
                                                                   ['move', [1, 7], [3, 7]])

            allow(@ai_double).to receive(:make_move).and_return([[6, 4], [4, 4]],
                                                                [[7, 5], [3, 1]])

            subject.default_start

            2.times do
              subject.play_round
            end

            is_in_check = subject.player_in_check

            expect(is_in_check).to be true
          end

          it 'stops on checkmate' do
            @ai_double = instance_double(AiPlayer)
            @input_double = class_double(Input_Manager)

            subject.ai_player = @ai_double
            subject.input_manager = @input_double

            allow(@ai_double).to receive(:color=).with('black')
            allow(@ai_double).to receive(:color).and_return('black')

            # d2 -> d4 w
            # e7 -> e5 b
            # h2 -> h4 w
            # f8 -> b4 b - check
            # c1 -> d2 w - break check
            # ['move', [2, 0], [3, 1]]
            allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]],
                                                                   ['move', [1, 7], [3, 7]])

            allow(@ai_double).to receive(:make_move).and_return([[6, 4], [4, 4]],
                                                                [[7, 5], [3, 1]])

            subject.default_start

            2.times do
              subject.play_round
            end

            # is_in_check = subject.player_in_check

            expect(subject.checkmate).to be true
          end
        end

        xit 'prints the board after each round' do
        end
      end

      context 'Move history tests' do
        it 'updates the capture & move history of the board' do
          @ai_double = instance_double(AiPlayer)
          @input_double = class_double(Input_Manager)

          subject.ai_player = @ai_double
          subject.input_manager = @input_double

          allow(@ai_double).to receive(:color=).with('black')
          allow(@ai_double).to receive(:color).and_return('black')

          allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]],
                                                                 ['move', [1, 4], [3, 4]],
                                                                 ['move', [3, 3], [4, 3]])

          allow(@ai_double).to receive(:make_move).and_return([[6, 3], [4, 3]],
                                                              [[6, 1], [5, 1]],
                                                              [[6, 2], [5, 2]])

          subject.default_start

          3.times do
            subject.play_round
          end

          capture_history_is_empty = subject.get_capture_history.empty?
          move_history_is_empty = subject.get_full_move_history.empty?

          expect(capture_history_is_empty).to be false
          expect(move_history_is_empty).to be false
        end
      end
    end

    describe '#start_message' do
      it 'returns a start message' do
        expect(subject.start_message).to eq('Welcome to chess, game will start shortly!')
      end
    end

    describe '#set_default_colors' do
      it 'sets player to white and ai to black' do
        # default colors is now a private function, but this function calls it
        subject.default_start

        expect(subject.player.color).to eq('white')
        expect(subject.ai_player.color).to eq('black')
      end
    end

    describe '#set_board, #show_board' do
      it 'sets the pieces on the board' do
        # set board is now a private function, but this function calls it
        subject.default_start
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

      it 'returns quit for quit input' do
        allow(@input_double).to receive(:play_turn).and_return('quit')

        expect(subject.player_turn).to eq('quit')
      end

      it 'handles save input' do
        expect(subject).to receive(:player_used_save)
        allow(@input_double).to receive(:play_turn).and_return('save')
        subject.player_turn
      end

      it 'handles load input' do
        expect(subject).to receive(:player_used_load)
        allow(@input_double).to receive(:play_turn).and_return('load')

        subject.player_turn
      end
    end
  end

  context 'Save/Load Functions' do
    xit '(placeholder) can save a game' do
    end

    xit '(placeholder) can load a game' do
    end
  end
end
