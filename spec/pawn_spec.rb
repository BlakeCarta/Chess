require_relative '../lib/Pieces/piece'
require_relative './helpers/board_manager_spec_helper'

RSpec.configure do |c|
  c.include BOARD_MANAGER_HELPER, :include_bm_helper
end
describe Piece do
  describe 'Piece_functions' do
    subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'white') }

    let(:posistion) { [1, 0] }
    let(:type) { 'pawn' }

    describe '#get_posistion' do
      it 'returns the original posistion' do
        expected = posistion
        expect(subject.get_posistion).to eq(expected)
      end
    end

    describe '#name' do
      it 'returns "pawn" for name' do
        name = 'pawn'
        expect(subject.name).to eq(name)
      end
    end

    describe '#color' do
      it 'returns the correct given color' do
        expected = 'white'
        expect(subject.color).to eq(expected)
      end
    end

    describe '#icon' do
      it 'returns the correct icon (P)' do
        expected = 'P'
        expect(subject.icon).to eq(expected)
      end
    end

    describe '#move_history' do
      it 'returns an empty list when initialized' do
        expect(subject.move_history).to be_empty
      end

      it 'correctly stores forced past moves' do
        expected = [posistion, [2, 0], [3, 0]]

        subject.set_new_posistion([2, 0])
        subject.set_new_posistion([3, 0])
        subject.set_new_posistion([4, 0])

        expect(subject.move_history).to eq(expected)
      end
    end
  end

  describe 'Piece_functions (movements)', :include_bm_helper do
    subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'white') }

    let(:empty_square) { 'x' }
    let(:posistion) { [1, 0] }
    let(:type) { 'pawn' }

    before do
      @board_manager = double('Board_Manager')

      @black_pawn = instance_double('Piece', name: 'pawn', color: 'black')
      @black_rook = instance_double('Piece', name: 'rook', color: 'black')
      @black_knight = instance_double('Piece', name: 'knight', color: 'black')
      @black_bishop = instance_double('Piece', name: 'bishop', color: 'black')
      @black_queen = instance_double('Piece', name: 'queen', color: 'black')
      @black_king = instance_double('Piece', name: 'king', color: 'black')

      @white_pawn = instance_double('Piece', name: 'pawn', color: 'white')
      @white_rook = instance_double('Piece', name: 'rook', color: 'white')
      @white_knight = instance_double('Piece', name: 'knight', color: 'white')
      @white_bishop = instance_double('Piece', name: 'bishop', color: 'white')
      @white_queen = instance_double('Piece', name: 'queen', color: 'white')
      @white_king = instance_double('Piece', name: 'king', color: 'white')
    end

    context 'empty board' do
      describe '#get_moves' do
        it 'returns two moves in a simple example' do
          # allow(@board_manager).to receive(:get_location) {empty_square}
          get_location_allow_empty({ board_manager: @board_manager })
          expected = [[2, 0], [3, 0]]
          return_cords = true

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end

        it 'only does 1 square worth of move' do
          new_posistion = [3, 3]
          subject.set_new_posistion(new_posistion)

          arguments_hash = { board_manager: @board_manager,
                             black_posistions: [],
                             white_posistions: [],
                             piece: piece,
                             basic_black_piece: nil,
                             basic_white_piece: nil,
                             posistion: new_posistion }

          get_location_allow_all(arguments_hash)

          expected = [[4, 3]]
          return_cords = true

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end
      end
    end

    context 'sparse board' do
      let(:black_posistions) { [[4, 7], [5, 5], [1, 2]] }
      let(:white_posistions) { [[1, 1]] }

      describe '#get_moves', :include_bm_helper do
        it 'can capture an enemy piece' do
          new_posistion = [3, 7]
          subject.set_new_posistion(new_posistion)

          return_cords = true
          expected = [[4, 7]]

          arguments_hash = { board_manager: @board_manager,
                             black_posistions: black_posistions,
                             white_posistions: white_posistions,
                             piece: piece,
                             basic_black_piece: @black_pawn,
                             basic_white_piece: @white_pawn,
                             posistion: new_posistion }

          get_location_allow_all(arguments_hash)

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end

        it 'cant move past a friendly piece' do
          new_posistion = [0, 1]
          subject.set_new_posistion(new_posistion)

          return_cords = true
          expected = []

          arguments_hash = { board_manager: @board_manager,
                             black_posistions: black_posistions,
                             white_posistions: white_posistions,
                             piece: piece,
                             basic_black_piece: @black_pawn,
                             basic_white_piece: @white_pawn,
                             posistion: new_posistion }

          get_location_allow_all(arguments_hash)

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end

        context 'black en_passnat' do
          subject(:piece) { Piece.new(type: type, posistion: [6, 1], color: 'black') }

          it '(pawn) can en-passant', :include_bm_helper do
            new_posistion = [4, 1]
            subject.set_new_posistion(new_posistion)
            new_posistion = [3, 1]
            subject.set_new_posistion(new_posistion)

            en_passant = { original_capturing_posistion: new_posistion, original_captured_posistion: [3, 2],
                           new_capturing_posistion: [2, 2], can_capture: true }

            return_cords = true
            expected = [[2, 1], en_passant]

            arguments_hash = { board_manager: @board_manager,
                               black_posistions: [],
                               white_posistions: [[3, 2], [2, 1]],
                               piece: piece,
                               basic_black_piece: @black_pawn,
                               basic_white_piece: @white_pawn }

            get_location_allow_all(arguments_hash)
            allow(@white_pawn).to receive(:move_history).and_return([3, 2])
            allow(@board_manager).to receive(:full_move_history).and_return([3, 2])

            expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
          end
        end

        context 'white en_passnat' do
          subject(:piece) { Piece.new(type: type, posistion: [0, 2], color: 'white') }

          it '(pawn) can en-passant', :include_bm_helper do
            new_posistion = [3, 2]
            subject.set_new_posistion(new_posistion)
            new_posistion = [4, 2]
            subject.set_new_posistion(new_posistion)

            en_passant = { original_capturing_posistion: new_posistion, original_captured_posistion: [4, 3],
                           new_capturing_posistion: [5, 3], can_capture: true }

            return_cords = true
            expected = [[5, 2], en_passant]

            arguments_hash = { board_manager: @board_manager,
                               black_posistions: [[4, 3], [5, 4]],
                               white_posistions: [],
                               piece: piece,
                               basic_black_piece: @black_pawn,
                               basic_white_piece: @white_pawn }

            get_location_allow_all(arguments_hash)
            allow(@black_pawn).to receive(:move_history).and_return([6, 4])
            allow(@board_manager).to receive(:full_move_history).and_return([6, 4])

            expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
          end

          it '*cant capture if waited a turn' do
            new_posistion = [3, 2]
            subject.set_new_posistion(new_posistion)
            new_posistion = [4, 2]
            subject.set_new_posistion(new_posistion)

            en_passant = { original_capturing_posistion: new_posistion, original_captured_posistion: [4, 3],
                           new_capturing_posistion: [5, 3], can_capture: false }

            return_cords = true
            expected = [[5, 2], en_passant]

            arguments_hash = { board_manager: @board_manager,
                               black_posistions: [[4, 3], [5, 4]],
                               white_posistions: [],
                               piece: piece,
                               basic_black_piece: @black_pawn,
                               basic_white_piece: @white_pawn }

            get_location_allow_all(arguments_hash)
            allow(@black_pawn).to receive(:move_history).and_return([6, 4])
            allow(@board_manager).to receive(:full_move_history).and_return([[3, 2], [1, 1], [4, 2], [6, 4]])

            expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
          end
        end
      end
    end

    context 'default board' do
      before do
        @default_arguments_hash = { board_manager: @board_manager,
                                    black_rook: @black_rook,
                                    white_rook: @white_rook,
                                    black_knight: @black_knight,
                                    white_knight: @white_knight,
                                    black_bishop: @black_bishop,
                                    white_bishop: @white_bishop,
                                    black_queen: @black_queen,
                                    white_queen: @white_queen,
                                    black_king: @black_king,
                                    white_king: @white_king,
                                    # piece: piece,
                                    black_pawn: @black_pawn,
                                    white_pawn: @white_pawn }
        # posistion: new_posistion
      end

      context 'white pawns' do
        # subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'white') }
        8.times do |i|
          new_posistion = [1, i]
          # subject.set_new_posistion(new_posistion)
          context 'pawn iterator' do
            subject(:piece) { Piece.new(type: type, posistion: new_posistion, color: 'white') }

            it 'returns only 2 valid moves' do
              @default_arguments_hash[:piece] = piece
              @default_arguments_hash[:posistion] = new_posistion
              get_default_board_allow(@default_arguments_hash)

              expected = [[2, i], [3, i]]

              return_cords = true

              inter = subject.get_moves(@board_manager, return_cords)

              expect(inter).to match_array(expected)
            end
          end
        end
      end

      context 'black pawns' do
        # subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'white') }
        8.times do |i|
          new_posistion = [6, i]
          # subject.set_new_posistion(new_posistion)

          context 'pawn iterator' do
            subject(:piece) { Piece.new(type: type, posistion: new_posistion, color: 'black') }

            it 'returns only 2 valid moves' do
              @default_arguments_hash[:piece] = piece
              @default_arguments_hash[:posistion] = new_posistion
              get_default_board_allow(@default_arguments_hash)

              expected = [[5, i], [4, i]]

              return_cords = true

              expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
            end
          end
        end
      end
    end
  end
end
