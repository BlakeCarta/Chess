require_relative '../lib/game_manager'
require_relative '../lib/Pieces/piece'
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

    describe 'Can #play_game from beginning to end' do
      it 'First ten moves match expected board state' do
        @ai_double = instance_double(AiPlayer)
        @input_double = class_double(Input_Manager)

        subject.ai_player = @ai_double
        subject.input_manager = @input_double

        allow(@ai_double).to receive(:color=).with('black')
        allow(@ai_double).to receive(:color).and_return('black')
        # player - white
        # d2 -> d4 1,3 3,3
        # e2 - e3 1,4 2,4
        # f2 - f4 1,5 3,5
        # a2 - a4 1,0 3,0
        # f1 - b5 0,5 4,1
        # d1 - g4 0,3 3,6
        # b1 - c3 0,1 2,2
        # a4 - a5 3,0 4,0
        # d4 - d5 3,3 4,3
        # c3 - a4 2,2 3,0
        allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]],
                                                               ['move', [1, 4], [2, 4]],
                                                               ['move', [1, 5], [3, 5]],
                                                               ['move', [1, 0], [3, 0]],
                                                               ['move', [0, 5], [4, 1]],
                                                               ['move', [0, 3], [3, 6]],
                                                               ['move', [0, 1], [2, 2]],
                                                               ['move', [3, 0], [4, 0]],
                                                               ['move', [3, 3], [4, 3]],
                                                               ['move', [2, 2], [3, 0]])

        # ai - black
        # b7 -> b5 6,1 4,1
        # g7 - g5 6,6 4,6
        # f8 - h6 7,5 5,7
        # c8 - a6 7,2 5,0
        # c7 - c6 6,2 5,2
        # g8 - f6 7,6 5,5
        # f6 - g4 5,5 3,6
        # c6 - b5 5,2 4,1
        # e7 - e6 6,4 5,4
        # d8 - a5 7,3 4,0
        allow(@ai_double).to receive(:make_move).and_return([[6, 1], [4, 1]],
                                                            [[6, 6], [4, 6]],
                                                            [[7, 5], [5, 7]],
                                                            [[7, 2], [5, 0]],
                                                            [[6, 2], [5, 2]],
                                                            [[7, 6], [5, 5]],
                                                            [[5, 5], [3, 6]],
                                                            [[5, 2], [4, 1]],
                                                            [[6, 4], [5, 4]],
                                                            [[7, 3], [4, 0]])
        subject.default_start

        round_successful = []

        10.times do |i|
          round_successful = subject.play_round
          expect(round_successful).to be true
        end

        expected_board_state = Board_Manager.new
        expected_board_state.set_location([0, 7], Piece.new(type: 'rook', posistion: [0, 7], color: 'white'))
        expected_board_state.set_location([0, 6], Piece.new(type: 'knight', posistion: [0, 6], color: 'white'))
        expected_board_state.set_location([0, 4], Piece.new(type: 'king', posistion: [0, 4], color: 'white'))
        expected_board_state.set_location([0, 2], Piece.new(type: 'bishop', posistion: [0, 2], color: 'white'))
        expected_board_state.set_location([0, 0], Piece.new(type: 'rook', posistion: [0, 0], color: 'white'))

        expected_board_state.set_location([1, 7], Piece.new(type: 'pawn', posistion: [1, 7], color: 'white'))
        expected_board_state.set_location([1, 6], Piece.new(type: 'pawn', posistion: [1, 6], color: 'white'))
        expected_board_state.set_location([1, 2], Piece.new(type: 'pawn', posistion: [1, 2], color: 'white'))
        expected_board_state.set_location([1, 1], Piece.new(type: 'pawn', posistion: [1, 1], color: 'white'))

        expected_board_state.set_location([2, 4], Piece.new(type: 'pawn', posistion: [2, 4], color: 'white'))

        expected_board_state.set_location([3, 6], Piece.new(type: 'knight', posistion: [3, 6], color: 'black'))
        expected_board_state.set_location([3, 5], Piece.new(type: 'pawn', posistion: [3, 5], color: 'white'))
        expected_board_state.set_location([3, 0], Piece.new(type: 'knight', posistion: [3, 0], color: 'white'))

        expected_board_state.set_location([4, 6], Piece.new(type: 'pawn', posistion: [4, 6], color: 'black'))
        expected_board_state.set_location([4, 3], Piece.new(type: 'pawn', posistion: [4, 3], color: 'white'))
        expected_board_state.set_location([4, 1], Piece.new(type: 'pawn', posistion: [4, 1], color: 'black'))
        expected_board_state.set_location([4, 0], Piece.new(type: 'queen', posistion: [4, 0], color: 'black'))

        expected_board_state.set_location([5, 7], Piece.new(type: 'bishop', posistion: [5, 6], color: 'black'))
        expected_board_state.set_location([5, 4], Piece.new(type: 'pawn', posistion: [5, 4], color: 'black'))
        expected_board_state.set_location([5, 0], Piece.new(type: 'bishop', posistion: [5, 0], color: 'black'))

        expected_board_state.set_location([6, 7], Piece.new(type: 'pawn', posistion: [6, 7], color: 'black'))
        expected_board_state.set_location([6, 5], Piece.new(type: 'pawn', posistion: [6, 5], color: 'black'))
        expected_board_state.set_location([6, 3], Piece.new(type: 'pawn', posistion: [6, 3], color: 'black'))
        expected_board_state.set_location([6, 0], Piece.new(type: 'pawn', posistion: [6, 0], color: 'black'))

        expected_board_state.set_location([7, 7], Piece.new(type: 'rook', posistion: [7, 7], color: 'black'))
        expected_board_state.set_location([7, 4], Piece.new(type: 'king', posistion: [7, 4], color: 'black'))
        expected_board_state.set_location([7, 1], Piece.new(type: 'knight', posistion: [7, 1], color: 'black'))
        expected_board_state.set_location([7, 0], Piece.new(type: 'rook', posistion: [7, 0], color: 'black'))

        # check pieces
        expected_board_state.get_board.each_with_index do |row, rindex|
          row.each_with_index do |item, cindex|
            if item.is_a?(String)
              expect(subject.show_board[rindex][cindex].is_a?(String)).to be true
            else
              expect(subject.show_board[rindex][cindex].name).to eq(item.name)
              expect(subject.show_board[rindex][cindex].color).to eq(item.color)
            end
          end
        end
      end

      it 'plays the first 20 moves correctly' do
        @ai_double = instance_double(AiPlayer)
        @input_double = class_double(Input_Manager)

        subject.ai_player = @ai_double
        subject.input_manager = @input_double

        allow(@ai_double).to receive(:color=).with('black')
        allow(@ai_double).to receive(:color).and_return('black')
        # player - white
        # d2 -> d4 1,3 3,3
        # e2 - e3 1,4 2,4
        # f2 - f4 1,5 3,5
        # a2 - a4 1,0 3,0
        # f1 - b5 0,5 4,1
        # d1 - g4 0,3 3,6
        # b1 - c3 0,1 2,2
        # a4 - a5 3,0 4,0
        # d4 - d5 3,3 4,3
        # c3 - a4 2,2 3,0
        # c2 - c3 1,2 2,2
        # h2 - h4 1,7 3,7
        # h1 - h3 0,7 2,7
        # h4 - g5 3,7 4,6
        # f4 - g5 3,5 4,6
        # a1 - a3 0,0 2,0
        # h3 - h7 2,7 6,7
        # g1 - e2 0,6 1,4
        # b2 - b4 1,1 3,1
        # e2 - g3 1,4 2,6
        # e3 - d4 2,4 3,3
        allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]],
                                                               ['move', [1, 4], [2, 4]],
                                                               ['move', [1, 5], [3, 5]],
                                                               ['move', [1, 0], [3, 0]],
                                                               ['move', [0, 5], [4, 1]],
                                                               ['move', [0, 3], [3, 6]],
                                                               ['move', [0, 1], [2, 2]],
                                                               ['move', [3, 0], [4, 0]],
                                                               ['move', [3, 3], [4, 3]],
                                                               ['move', [2, 2], [3, 0]],
                                                               ['move', [1, 2], [2, 2]],
                                                               ['move', [1, 7], [3, 7]],
                                                               ['move', [0, 7], [2, 7]],
                                                               ['move', [3, 7], [4, 6]],
                                                               ['move', [3, 5], [4, 6]],
                                                               ['move', [0, 0], [2, 0]],
                                                               ['move', [2, 7], [6, 7]],
                                                               ['move', [0, 6], [1, 4]],
                                                               ['move', [1, 1], [3, 1]],
                                                               ['move', [1, 4], [2, 6]],
                                                               ['move', [2, 4], [3, 3]])

        # ai - black
        # b7 -> b5 6,1 4,1
        # g7 - g5 6,6 4,6
        # f8 - h6 7,5 5,7
        # c8 - a6 7,2 5,0
        # c7 - c6 6,2 5,2
        # g8 - f6 7,6 5,5
        # f6 - g4 5,5 3,6
        # c6 - b5 5,2 4,1
        # e7 - e6 6,4 5,4
        # d8 - a5 7,3 4,0
        # b5 - a4 4,1 3,0
        # e6 - d5 5,4 4,3
        # f7 - f6 6,5 5,5
        # f6 - g5 5,5 4,6
        # h6 - g5 5,7 4,6
        # h8 - f8 7,7 7,5
        # g4 - f6 3,6 5,5
        # f6 - h7 5,5 6,7
        # a5 - b5 4,0 4,1
        # d5 - d4 4,3 3,3
        allow(@ai_double).to receive(:make_move).and_return([[6, 1], [4, 1]],
                                                            [[6, 6], [4, 6]],
                                                            [[7, 5], [5, 7]],
                                                            [[7, 2], [5, 0]],
                                                            [[6, 2], [5, 2]],
                                                            [[7, 6], [5, 5]],
                                                            [[5, 5], [3, 6]],
                                                            [[5, 2], [4, 1]],
                                                            [[6, 4], [5, 4]],
                                                            [[7, 3], [4, 0]],
                                                            [[4, 1], [3, 0]],
                                                            [[5, 4], [4, 3]],
                                                            [[6, 5], [5, 5]],
                                                            [[5, 5], [4, 6]],
                                                            [[5, 7], [4, 6]],
                                                            [[7, 7], [7, 5]],
                                                            [[3, 6], [5, 5]],
                                                            [[5, 5], [6, 7]],
                                                            [[4, 0], [4, 1]],
                                                            [[4, 3], [3, 3]])
        subject.default_start

        round_successful = []

        20.times do |i|
          round_successful = subject.play_round
          expect(round_successful).to be true
        end

        expected_board_state = Board_Manager.new
        expected_board_state.set_location([0, 4], Piece.new(type: 'king', posistion: [0, 4], color: 'white'))
        expected_board_state.set_location([0, 2], Piece.new(type: 'bishop', posistion: [0, 2], color: 'white'))

        expected_board_state.set_location([1, 6], Piece.new(type: 'pawn', posistion: [1, 6], color: 'white'))

        expected_board_state.set_location([2, 6], Piece.new(type: 'knight', posistion: [2, 6], color: 'white'))
        expected_board_state.set_location([2, 4], Piece.new(type: 'pawn', posistion: [2, 4], color: 'white'))
        expected_board_state.set_location([2, 2], Piece.new(type: 'pawn', posistion: [2, 2], color: 'white'))
        expected_board_state.set_location([2, 0], Piece.new(type: 'rook', posistion: [2, 0], color: 'white'))

        expected_board_state.set_location([3, 0], Piece.new(type: 'pawn', posistion: [3, 0], color: 'black'))
        expected_board_state.set_location([3, 1], Piece.new(type: 'pawn', posistion: [3, 1], color: 'white'))
        expected_board_state.set_location([3, 3], Piece.new(type: 'pawn', posistion: [3, 3], color: 'black'))

        expected_board_state.set_location([4, 6], Piece.new(type: 'bishop', posistion: [4, 6], color: 'black'))
        expected_board_state.set_location([4, 1], Piece.new(type: 'queen', posistion: [4, 1], color: 'black'))

        expected_board_state.set_location([5, 0], Piece.new(type: 'bishop', posistion: [5, 0], color: 'black'))

        expected_board_state.set_location([6, 7], Piece.new(type: 'knight', posistion: [6, 7], color: 'black'))
        expected_board_state.set_location([6, 3], Piece.new(type: 'pawn', posistion: [6, 3], color: 'black'))
        expected_board_state.set_location([6, 0], Piece.new(type: 'pawn', posistion: [6, 0], color: 'black'))

        expected_board_state.set_location([7, 5], Piece.new(type: 'rook', posistion: [7, 5], color: 'black'))
        expected_board_state.set_location([7, 4], Piece.new(type: 'king', posistion: [7, 4], color: 'black'))
        expected_board_state.set_location([7, 1], Piece.new(type: 'knight', posistion: [7, 1], color: 'black'))
        expected_board_state.set_location([7, 0], Piece.new(type: 'rook', posistion: [7, 0], color: 'black'))

        # check pieces
        expected_board_state.get_board.each_with_index do |row, rindex|
          row.each_with_index do |item, cindex|
            if item.is_a?(String)
              expect(subject.show_board[rindex][cindex].is_a?(String)).to be true
            else
              expect(subject.show_board[rindex][cindex].name).to eq(item.name)
              expect(subject.show_board[rindex][cindex].color).to eq(item.color)
            end
          end
        end
      end

      it 'plays the full game' do
        @ai_double = instance_double(AiPlayer)
        @input_double = class_double(Input_Manager)

        subject.ai_player = @ai_double
        subject.input_manager = @input_double

        allow(@ai_double).to receive(:color=).with('black')
        allow(@ai_double).to receive(:color).and_return('black')

        allow(@input_double).to receive(:get_upgrade).and_return('queen')
        allow(@ai_double).to receive(:get_upgrade).and_return('queen')
        # d2 -> d4 1,3 3,3
        # e2 - e3 1,4 2,4
        # f2 - f4 1,5 3,5
        # a2 - a4 1,0 3,0
        # f1 - b5 0,5 4,1
        # d1 - g4 0,3 3,6
        # b1 - c3 0,1 2,2
        # a4 - a5 3,0 4,0
        # d4 - d5 3,3 4,3
        # c3 - a4 2,2 3,0
        # c2 - c3 1,2 2,2
        # h2 - h4 1,7 3,7
        # h1 - h3 0,7 2,7
        # h4 - g5 3,7 4,6
        # f4 - g5 3,5 4,6
        # a1 - a3 0,0 2,0
        # h3 - h7 2,7 6,7
        # g1 - e2 0,6 1,4
        # b2 - b4 1,1 3,1
        # e2 - g3 1,4 2,6
        # e3 - d4 2,4 3,3
        # a3 - b3 2,0 2,1
        # c3 - c4 2,2 3,2
        # e1 - e2 0,4 1,4
        # e2 - e1 1,4 0,4
        # g3 - e4 2,6 3,4
        # e1 - d1 0,4 0,3
        # g2 - g3 1,6 2,6
        # d1 - d2 0,3 1,3
        # g3 - g4 2,6 3,6
        # g4 - g5 3,6 4,6
        # g5 - g6 4,6 5,6
        # g6 - g7 5,6 6,6

        allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]],
                                                               ['move', [1, 4], [2, 4]],
                                                               ['move', [1, 5], [3, 5]],
                                                               ['move', [1, 0], [3, 0]],
                                                               ['move', [0, 5], [4, 1]],
                                                               ['move', [0, 3], [3, 6]],
                                                               ['move', [0, 1], [2, 2]],
                                                               ['move', [3, 0], [4, 0]],
                                                               ['move', [3, 3], [4, 3]],
                                                               ['move', [2, 2], [3, 0]],
                                                               ['move', [1, 2], [2, 2]],
                                                               ['move', [1, 7], [3, 7]],
                                                               ['move', [0, 7], [2, 7]],
                                                               ['move', [3, 7], [4, 6]],
                                                               ['move', [3, 5], [4, 6]],
                                                               ['move', [0, 0], [2, 0]],
                                                               ['move', [2, 7], [6, 7]],
                                                               ['move', [0, 6], [1, 4]],
                                                               ['move', [1, 1], [3, 1]],
                                                               ['move', [1, 4], [2, 6]],
                                                               ['move', [2, 4], [3, 3]],
                                                               ['move', [2, 0], [2, 1]],
                                                               ['move', [2, 2], [3, 2]],
                                                               ['move', [0, 4], [1, 4]],
                                                               ['move', [1, 4], [0, 4]],
                                                               ['move', [2, 6], [3, 4]],
                                                               ['move', [0, 4], [0, 3]],
                                                               ['move', [1, 6], [2, 6]],
                                                               ['move', [0, 3], [1, 3]],
                                                               ['move', [2, 6], [3, 6]],
                                                               ['move', [3, 6], [4, 6]],
                                                               ['move', [4, 6], [5, 6]],
                                                               ['move', [5, 6], [6, 6]])

        # b7 -> b5 6,1 4,1
        # g7 - g5 6,6 4,6
        # f8 - h6 7,5 5,7
        # c8 - a6 7,2 5,0
        # c7 - c6 6,2 5,2
        # g8 - f6 7,6 5,5
        # f6 - g4 5,5 3,6
        # c6 - b5 5,2 4,1
        # e7 - e6 6,4 5,4
        # d8 - a5 7,3 4,0
        # b5 - a4 4,1 3,0
        # e6 - d5 5,4 4,3
        # f7 - f6 6,5 5,5
        # f6 - g5 5,5 4,6
        # h6 - g5 5,7 4,6
        # h8 - f8 7,7 7,5
        # g4 - f6 3,6 5,5
        # f6 - h7 5,5 6,7
        # a5 - b5 4,0 4,1
        # d5 - d4 4,3 3,3
        # g5 - c1 4,6 0,2
        # a4 - b3 3,0 2,1
        # b5 - b4 4,1 3,1
        # b4 - c4 3,1 3,2
        # c4 - d4 3,2 3,3
        # d4 - e4 3,3 3,4
        # c1 - b2 0,2 1,1
        # f8 - f1 7,5 0,5
        # b2 - d4 1,1 3,3
        # b3 - b2 2,1 1,1
        # b2 - b1 - pawn up to queen 1,1 1,0
        # h7 - f6 6,7 5,5
        # b1 - b2 into checkmate 0,1 1,1

        allow(@ai_double).to receive(:make_move).and_return([[6, 1], [4, 1]],
                                                            [[6, 6], [4, 6]],
                                                            [[7, 5], [5, 7]],
                                                            [[7, 2], [5, 0]],
                                                            [[6, 2], [5, 2]],
                                                            [[7, 6], [5, 5]],
                                                            [[5, 5], [3, 6]],
                                                            [[5, 2], [4, 1]],
                                                            [[6, 4], [5, 4]],
                                                            [[7, 3], [4, 0]],
                                                            [[4, 1], [3, 0]],
                                                            [[5, 4], [4, 3]],
                                                            [[6, 5], [5, 5]],
                                                            [[5, 5], [4, 6]],
                                                            [[5, 7], [4, 6]],
                                                            [[7, 7], [7, 5]],
                                                            [[3, 6], [5, 5]],
                                                            [[5, 5], [6, 7]],
                                                            [[4, 0], [4, 1]],
                                                            [[4, 3], [3, 3]],
                                                            [[4, 6], [0, 2]],
                                                            [[3, 0], [2, 1]],
                                                            [[4, 1], [3, 1]],
                                                            [[3, 1], [3, 2]],
                                                            [[3, 2], [3, 3]],
                                                            [[3, 3], [3, 4]],
                                                            [[0, 2], [1, 1]],
                                                            [[7, 5], [0, 5]],
                                                            [[1, 1], [3, 3]],
                                                            [[2, 1], [1, 1]],
                                                            [[1, 1], [0, 1]],
                                                            [[6, 7], [5, 5]],
                                                            [[0, 1], [1, 1]])

        subject.default_start

        subject.play_game

        expected_board_state = Board_Manager.new
        expected_board_state.set_location([0, 5], Piece.new(type: 'rook', posistion: [0, 5], color: 'black'))

        expected_board_state.set_location([1, 3], Piece.new(type: 'king', posistion: [1, 3], color: 'white'))
        expected_board_state.set_location([1, 1], Piece.new(type: 'queen', posistion: [1, 1], color: 'black'))

        expected_board_state.set_location([3, 4], Piece.new(type: 'queen', posistion: [3, 4], color: 'black'))
        expected_board_state.set_location([3, 3], Piece.new(type: 'bishop', posistion: [3, 3], color: 'black'))

        expected_board_state.set_location([5, 5], Piece.new(type: 'knight', posistion: [5, 5], color: 'black'))
        expected_board_state.set_location([5, 0], Piece.new(type: 'bishop', posistion: [5, 0], color: 'black'))

        expected_board_state.set_location([6, 6], Piece.new(type: 'pawn', posistion: [6, 6], color: 'white'))
        expected_board_state.set_location([6, 3], Piece.new(type: 'pawn', posistion: [6, 3], color: 'black'))
        expected_board_state.set_location([6, 0], Piece.new(type: 'pawn', posistion: [6, 0], color: 'black'))

        expected_board_state.set_location([7, 4], Piece.new(type: 'king', posistion: [7, 4], color: 'black'))
        expected_board_state.set_location([7, 1], Piece.new(type: 'knight', posistion: [7, 1], color: 'black'))
        expected_board_state.set_location([7, 0], Piece.new(type: 'rook', posistion: [7, 0], color: 'black'))

        # check pieces
        expected_board_state.get_board.each_with_index do |row, rindex|
          row.each_with_index do |item, cindex|
            if item.is_a?(String)
              expect(subject.show_board[rindex][cindex].is_a?(String)).to be true
            else
              expect(subject.show_board[rindex][cindex].name).to eq(item.name)
              expect(subject.show_board[rindex][cindex].color).to eq(item.color)
            end
          end
        end
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

          it '(fools mate) detects checkmate' do
            @ai_double = instance_double(AiPlayer)
            @input_double = class_double(Input_Manager)

            subject.ai_player = @ai_double
            subject.input_manager = @input_double

            # white to f2 - f3
            # black to e7 - e5
            # white to g2 - g4
            # black queen to d8 - h4
            # white in checkmate

            allow(@ai_double).to receive(:color=).with('black')
            allow(@ai_double).to receive(:color).and_return('black')

            allow(@input_double).to receive(:play_turn).and_return(['move', [1, 5], [2, 5]],
                                                                   ['move', [1, 6], [3, 6]])

            allow(@ai_double).to receive(:make_move).and_return([[6, 4], [4, 4]],
                                                                [[7, 3], [3, 7]])

            subject.default_start

            2.times do
              subject.play_round
            end

            # this test doesnt actually work fix later
            expect(subject.checkmate).to be true
          end
        end

        it 'prints the board after each round' do
          @ai_double = instance_double(AiPlayer)
          @input_double = class_double(Input_Manager)

          subject.ai_player = @ai_double
          subject.input_manager = @input_double

          allow(@ai_double).to receive(:color=).with('black')
          allow(@ai_double).to receive(:color).and_return('black')

          allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]])

          allow(@ai_double).to receive(:make_move).and_return([[6, 4], [4, 4]])

          subject.default_start

          expect(subject).to receive(:print_board).exactly(3).times
          subject.play_round
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
                                                                 ['move', [1, 4], [3, 4]])
          # invalid move
          # ,['move', [3, 3], [4, 3]]

          allow(@ai_double).to receive(:make_move).and_return([[6, 3], [4, 3]],
                                                              [[6, 1], [5, 1]])
          # not needed
          # ,[[6, 2], [5, 2]]

          subject.default_start

          2.times do
            subject.play_round
          end

          capture_history_is_empty = subject.get_capture_history.empty?
          move_history_is_empty = subject.get_full_move_history.empty?

          expect(capture_history_is_empty).to be true
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
    after do
      # remove test file after each test, to prevent cross contamination
      File.delete('./saves/test.yml') if File.exist?('./saves/test.yml')
    end

    it 'can save a game' do
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

      filename = 'test'
      data = {
        board: subject.board_manager.get_board,
        board_capture_history: subject.board_manager.capture_history,
        board_full_move_history: subject.board_manager.full_move_history,
        player: subject.player,
        ai_player: subject.ai_player,
        player_in_check: subject.player_in_check,
        ai_player_in_check: subject.ai_player_in_check,
        checkmate: subject.checkmate
      }
      STORAGE.save(filename, data)
      saved_games = Dir.entries('saves')

      expect(saved_games.any? { |e| e == "#{filename}.yml" }).to be true
    end

    it 'can load a game' do
      @ai_double = instance_double(AiPlayer)
      @input_double = class_double(Input_Manager)

      subject.ai_player = @ai_double
      subject.input_manager = @input_double

      allow(@ai_double).to receive(:color=).with('black')
      allow(@ai_double).to receive(:color).and_return('black')

      allow(@input_double).to receive(:play_turn).and_return(['move', [1, 4], [3, 4]],
                                                             ['move', [1, 7], [3, 7]])

      allow(@ai_double).to receive(:make_move).and_return([[6, 4], [4, 4]],
                                                          [[7, 5], [3, 1]])

      subject.default_start

      2.times do
        subject.play_round
      end

      filename = 'test'

      data = {
        board: subject.board_manager.get_board,
        board_capture_history: subject.board_manager.capture_history,
        board_full_move_history: subject.board_manager.full_move_history,
        player: subject.player,
        ai_player: subject.ai_player,
        player_in_check: subject.player_in_check,
        ai_player_in_check: subject.ai_player_in_check,
        checkmate: subject.checkmate
      }
      STORAGE.save(filename, data)

      saved_games = Dir.entries('saves')
      data = STORAGE.load(filename)
      # check each location has the same name and color or is empty
      board_location_checks = STORAGE.compare_board_data(subject.board_manager.get_board, data[:board])

      expect(board_location_checks.all?(true)).to be true
      expect(data[:player_in_check]).to eq(subject.player_in_check)
      expect(data[:ai_player_in_check]).to eq(subject.ai_player_in_check)
      expect(data[:checkmate]).to eq(subject.checkmate)

      Dir.entries('saves').each do |file|
        File.delete(file) if File.file?(file)
      end
    end

    it 'a piece can upgrade' do
      @ai_double = instance_double(AiPlayer)
      @input_double = class_double(Input_Manager)
      @board_manager = Board_Manager.new

      subject.ai_player = @ai_double
      subject.input_manager = @input_double
      subject.board_manager = @board_manager

      allow(@ai_double).to receive(:color=).with('black')
      allow(@ai_double).to receive(:color).and_return('black')

      expect(@input_double).to receive(:get_upgrade)

      @board_manager.set_location([6, 7], Piece.new(type: 'pawn', posistion: [6, 7], color: 'white'))
      @board_manager.set_location([6, 1], Piece.new(type: 'pawn', posistion: [6, 1], color: 'black'))
      allow(@input_double).to receive(:play_turn).and_return(['move', [6, 7], [7, 7]])
      allow(@input_double).to receive(:get_upgrade).and_return('queen')

      allow(@ai_double).to receive(:make_move).and_return([[6, 1], [4, 1]])
      subject.play_round

      expect(@board_manager.get_location([7, 7]).name).to eq('queen')
    end

    it 'can save & load a long game' do
      @ai_double = instance_double(AiPlayer)
      @input_double = class_double(Input_Manager)

      subject.ai_player = @ai_double
      subject.input_manager = @input_double

      allow(@ai_double).to receive(:color=).with('black')
      allow(@ai_double).to receive(:color).and_return('black')
      # d2 -> d4 1,3 3,3
      # e2 - e3 1,4 2,4
      # f2 - f4 1,5 3,5
      # a2 - a4 1,0 3,0
      # f1 - b5 0,5 4,1
      # d1 - g4 0,3 3,6
      # b1 - c3 0,1 2,2
      # a4 - a5 3,0 4,0
      # d4 - d5 3,3 4,3
      # c3 - a4 2,2 3,0
      # c2 - c3 1,2 2,2
      # h2 - h4 1,7 3,7
      # h1 - h3 0,7 2,7
      # h4 - g5 3,7 4,6
      # f4 - g5 3,5 4,6
      # a1 - a3 0,0 2,0
      # h3 - h7 2,7 6,7
      # g1 - e2 0,6 1,4
      # b2 - b4 1,1 3,1
      # e2 - g3 1,4 2,6
      # e3 - d4 2,4 3,3
      # a3 - b3 2,0 2,1
      # c3 - c4 2,2 3,2
      # e1 - e2 0,4 1,4
      # e2 - e1 1,4 0,4
      # g3 - e4 2,6 3,4
      # e1 - d1 0,4 0,3
      # g2 - g3 1,6 2,6
      # d1 - d2 0,3 1,3
      # g3 - g4 2,6 3,6
      # g4 - g5 3,6 4,6
      # g5 - g6 4,6 5,6
      # g6 - g7 5,6 6,6

      allow(@input_double).to receive(:play_turn).and_return(['move', [1, 3], [3, 3]],
                                                             ['move', [1, 4], [2, 4]],
                                                             ['move', [1, 5], [3, 5]],
                                                             ['move', [1, 0], [3, 0]],
                                                             ['move', [0, 5], [4, 1]],
                                                             ['move', [0, 3], [3, 6]],
                                                             ['move', [0, 1], [2, 2]],
                                                             ['move', [3, 0], [4, 0]],
                                                             ['move', [3, 3], [4, 3]],
                                                             ['move', [2, 2], [3, 0]],
                                                             ['move', [1, 2], [2, 2]],
                                                             ['move', [1, 7], [3, 7]],
                                                             ['move', [0, 7], [2, 7]],
                                                             ['move', [3, 7], [4, 6]],
                                                             ['move', [3, 5], [4, 6]],
                                                             ['move', [0, 0], [2, 0]],
                                                             ['move', [2, 7], [6, 7]],
                                                             ['move', [0, 6], [1, 4]],
                                                             ['move', [1, 1], [3, 1]],
                                                             ['move', [1, 4], [2, 6]],
                                                             ['move', [2, 4], [3, 3]],
                                                             ['move', [2, 0], [2, 1]],
                                                             ['move', [2, 2], [3, 2]],
                                                             ['move', [0, 4], [1, 4]],
                                                             ['move', [1, 4], [0, 4]],
                                                             ['move', [2, 6], [3, 4]],
                                                             ['move', [0, 4], [0, 3]],
                                                             ['move', [1, 6], [2, 6]],
                                                             ['move', [0, 3], [1, 3]],
                                                             ['move', [2, 6], [3, 6]],
                                                             ['move', [3, 6], [4, 6]],
                                                             ['move', [4, 6], [5, 6]],
                                                             ['move', [5, 6], [6, 6]])

      # b7 -> b5 6,1 4,1
      # g7 - g5 6,6 4,6
      # f8 - h6 7,5 5,7
      # c8 - a6 7,2 5,0
      # c7 - c6 6,2 5,2
      # g8 - f6 7,6 5,5
      # f6 - g4 5,5 3,6
      # c6 - b5 5,2 4,1
      # e7 - e6 6,4 5,4
      # d8 - a5 7,3 4,0
      # b5 - a4 4,1 3,0
      # e6 - d5 5,4 4,3
      # f7 - f6 6,5 5,5
      # f6 - g5 5,5 4,6
      # h6 - g5 5,7 4,6
      # h8 - f8 7,7 7,5
      # g4 - f6 3,6 5,5
      # f6 - h7 5,5 6,7
      # a5 - b5 4,0 4,1
      # d5 - d4 4,3 3,3
      # g5 - c1 4,6 0,2
      # a4 - b3 3,0 2,1
      # b5 - b4 4,1 3,1
      # b4 - c4 3,1 3,2
      # c4 - d4 3,2 3,3
      # d4 - e4 3,3 3,4
      # c1 - b2 0,2 1,1
      # f8 - f1 7,5 0,5
      # b2 - d4 1,1 3,3
      # b3 - b2 2,1 1,1
      # b2 - b1 - pawn up to queen 1,1 1,0
      # h7 - f6 6,7 5,5
      # b1 - b2 into checkmate 0,1 1,1

      allow(@ai_double).to receive(:make_move).and_return([[6, 1], [4, 1]],
                                                          [[6, 6], [4, 6]],
                                                          [[7, 5], [5, 7]],
                                                          [[7, 2], [5, 0]],
                                                          [[6, 2], [5, 2]],
                                                          [[7, 6], [5, 5]],
                                                          [[5, 5], [3, 6]],
                                                          [[5, 2], [4, 1]],
                                                          [[6, 4], [5, 4]],
                                                          [[7, 3], [4, 0]],
                                                          [[4, 1], [3, 0]],
                                                          [[5, 4], [4, 3]],
                                                          [[6, 5], [5, 5]],
                                                          [[5, 5], [4, 6]],
                                                          [[5, 7], [4, 6]],
                                                          [[7, 7], [7, 5]],
                                                          [[3, 6], [5, 5]],
                                                          [[5, 5], [6, 7]],
                                                          [[4, 0], [4, 1]],
                                                          [[4, 3], [3, 3]],
                                                          [[4, 6], [0, 2]],
                                                          [[3, 0], [2, 1]],
                                                          [[4, 1], [3, 1]],
                                                          [[3, 1], [3, 2]],
                                                          [[3, 2], [3, 3]],
                                                          [[3, 3], [3, 4]],
                                                          [[0, 2], [1, 1]],
                                                          [[7, 5], [0, 5]],
                                                          [[1, 1], [3, 3]],
                                                          [[2, 1], [1, 1]],
                                                          [[1, 1], [1, 0]],
                                                          [[6, 7], [5, 5]],
                                                          [[0, 1], [1, 1]])

      subject.default_start

      round_successful = []

      30.times do |i|
        round_successful = subject.play_round
        expect(round_successful).to be true
      end

      filename = 'test'

      data = {
        board: subject.board_manager.get_board,
        board_capture_history: subject.board_manager.capture_history,
        board_full_move_history: subject.board_manager.full_move_history,
        player: subject.player,
        ai_player: subject.ai_player,
        player_in_check: subject.player_in_check,
        ai_player_in_check: subject.ai_player_in_check,
        checkmate: subject.checkmate
      }
      STORAGE.save(filename, data)

      saved_games = Dir.entries('saves')
      data = STORAGE.load(filename)
      # check each location has the same name and color or is empty
      board_location_checks = STORAGE.compare_board_data(subject.board_manager.get_board, data[:board])

      expect(board_location_checks.all?(true)).to be true
      expect(data[:player_in_check]).to eq(subject.player_in_check)
      expect(data[:ai_player_in_check]).to eq(subject.ai_player_in_check)
      expect(data[:checkmate]).to eq(subject.checkmate)
    end
  end
end
