require_relative '../lib/Pieces/piece'
require_relative './helpers/board_manager_spec_helper'

RSpec.configure do |c|
  c.include BOARD_MANAGER_HELPER, :include_bm_helper
end
describe Piece do
  describe 'Piece_functions' do
    subject { Piece.new(type: type, posistion: posistion, color: 'white') }

    let(:posistion) { [1, 0] }
    let(:type) { 'king' }

    describe '#get_posistion' do
      it 'returns the original posistion' do
        expected = posistion
        expect(subject.get_posistion).to eq(expected)
      end
    end

    describe '#name' do
      it 'returns "king" for name' do
        name = 'king'
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
        expected = 'K'
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
    let(:type) { 'king' }

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

    describe '#get_moves' do
      context 'empty board' do
        it 'returns two moves in a simple example' do
          # allow(@board_manager).to receive(:get_location) {empty_square}
          get_location_allow_empty({ board_manager: @board_manager })
          expected = [[0, 0], [0, 1], [1, 1], [2, 0], [2, 1]]

          return_cords = true
          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end
      end

      context 'sparse board' do
        let(:black_posistions) { [[2, 2], [1, 1]] }
        let(:white_posistions) { [[1, 3], [0, 1]] }

        it 'acounts for friendly/enemy pieces' do
          new_posistion = [1, 2]
          subject.set_new_posistion(new_posistion)

          arguments_hash = { board_manager: @board_manager,
                             black_posistions: black_posistions,
                             white_posistions: white_posistions,
                             piece: piece,
                             basic_black_piece: @black_pawn,
                             basic_white_piece: @white_pawn,
                             posistion: new_posistion }

          get_location_allow_all(arguments_hash)

          expected = [[2, 2], [1, 1], [2, 1], [2, 3], [0, 3], [0, 2]]
          return_cords = true

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end

        context 'castle' do
          subject(:piece) { Piece.new(type: type, posistion: [0, 4], color: 'white') }

          it 'white (king) can castle left' do
            # new_posistion = [0, 4]
            # subject.set_new_posistion(new_posistion)

            arguments_hash = { board_manager: @board_manager,
                               black_posistions: [[]],
                               white_posistions: [[0, 0]],
                               piece: piece,
                               basic_black_piece: @empty_square,
                               basic_white_piece: @white_rook,
                               posistion: [0, 4] }

            get_location_allow_all(arguments_hash)
            allow(@white_rook).to receive(:move_history).and_return([])

            # get_location_allow_empty({ board_manager: @board_manager })
            # allow(@board_manager).to receive(:get_location) { @empty_square }

            # allow(@board_manager).to receive(:get_location).with([0, 0]).and_return(@white_rook)

            castle_move = { king_original_posistion: [0, 4], rook_original_posistion: [0, 0],
                            new_king_posistion: [0, 2], new_rook_posistion: [0, 3] }

            expected = [[0, 3], [0, 5], [1, 4], [1, 3], [1, 5], castle_move]
            return_cords = true

            expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
          end

          it 'white (king) can castle right' do
            # new_posistion = [0, 4]
            # subject.set_new_posistion(new_posistion)

            arguments_hash = { board_manager: @board_manager,
                               black_posistions: [[]],
                               white_posistions: [[0, 7]],
                               piece: piece,
                               basic_black_piece: @empty_square,
                               basic_white_piece: @white_rook,
                               posistion: [0, 4] }

            get_location_allow_all(arguments_hash)
            allow(@white_rook).to receive(:move_history).and_return([])

            # get_location_allow_empty({ board_manager: @board_manager })
            # allow(@board_manager).to receive(:get_location) { @empty_square }

            # allow(@board_manager).to receive(:get_location).with([0, 0]).and_return(@white_rook)

            castle_move = { king_original_posistion: [0, 4], rook_original_posistion: [0, 7],
                            new_king_posistion: [0, 6], new_rook_posistion: [0, 5] }

            expected = [[0, 3], [0, 5], [1, 4], [1, 3], [1, 5], castle_move]
            return_cords = true

            expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
          end
        end

        context 'black piece' do
          subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'black') }

          it 'acounts for friendly/enemy pieces' do
            new_posistion = [1, 2]
            subject.set_new_posistion(new_posistion)

            arguments_hash = { board_manager: @board_manager,
                               black_posistions: black_posistions,
                               white_posistions: white_posistions,
                               piece: piece,
                               basic_black_piece: @black_pawn,
                               basic_white_piece: @white_pawn,
                               posistion: new_posistion }

            get_location_allow_all(arguments_hash)

            expected = [[2, 1], [2, 3], [1, 3], [0, 1], [0, 3], [0, 2]]
            return_cords = true

            expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
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

        context 'e1 king' do
          subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'white') }

          it 'returns no valid moves' do
            new_posistion = [0, 4]
            subject.set_new_posistion(new_posistion)
            @default_arguments_hash[:piece] = piece
            @default_arguments_hash[:posistion] = new_posistion
            get_default_board_allow(@default_arguments_hash)

            return_cords = true

            expect(subject.get_moves(@board_manager, return_cords)).to be_empty
          end
        end

        context 'e8 king' do
          subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'black') }

          it 'returns no valid moves' do
            new_posistion = [7, 4]
            subject.set_new_posistion(new_posistion)
            @default_arguments_hash[:piece] = piece
            @default_arguments_hash[:posistion] = new_posistion
            get_default_board_allow(@default_arguments_hash)

            return_cords = true

            expect(subject.get_moves(@board_manager, return_cords)).to be_empty
          end
        end
      end
    end
  end
end
