require_relative '../lib/Pieces/piece.rb'
require_relative './helpers/board_manager_spec_helper.rb'

RSpec.configure do |c|
  c.include BOARD_MANAGER_HELPER, :include_bm_helper
end
describe Piece do
  describe 'Piece_functions' do
    let(:posistion) {[1,1]}
    let(:type) {'queen'}
    subject { Piece.new(type: type, posistion: posistion, color: 'white') }
    describe '#get_posistion' do
      it "returns the original posistion" do
        expected = posistion
        expect(subject.get_posistion).to eq(expected)
      end
    end

    describe '#name' do
      it 'returns "queen" for name' do
        name = 'queen'
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
      it 'returns the correct icon (Q)' do
        expected = 'Q'
        expect(subject.icon).to eq(expected)
      end
    end

    describe '#move_history' do
      it 'returns an empty list when initialized' do
        expect(subject.move_history).to be_empty
      end

      it 'correctly stores forced past moves' do
        expected = [posistion, [2,0], [3,0]]
        
        subject.set_new_posistion([2,0])
        subject.set_new_posistion([3,0])
        subject.set_new_posistion([4,0])

        expect(subject.move_history).to eq(expected)
      end
    end
  end

  describe 'Piece_functions (movements)' do
    let(:empty_square) {'x'}
    let(:posistion) {[1,1]}
    let(:type) {'queen'}

    subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'white') }

    before(:each) do   
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
    describe '#get_moves', :include_bm_helper do
      context 'empty board' do
        it 'returns two moves in a simple example' do
          #allow(@board_manager).to receive(:get_location) {empty_square}
          get_location_allow_empty({board_manager: @board_manager})
          expected = [[0,0],[0,1],[1,0],[2,0],[2,1],[3,1],[4,1],[5,1],[6,1],[7,1],[2,2],[3,3],[4,4],[5,5],[6,6],[7,7],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7],[0,2]]
          
          return_cords = true

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end
      end
      context 'sparse board (white piece)', :include_bm_helper do
        let(:black_posistions) {[[4,7], [7,2]]}
        let(:white_posistions) {[[6,6]]}
        it 'accounts for friendly & enemy pieces' do
          new_posistion = [7,7]
          subject.set_new_posistion(new_posistion)
          #get_location_allow_all({board_manager: @board_manager, black_posistions: black_posistions, white_posistions: white_posistions, piece: piece, basic_black_piece: @black_pawn, basic_white_piece: @white_pawn, posistion: new_posistion})
          #
          arguments_hash = { board_manager: @board_manager,
                             black_posistions: black_posistions,
                             white_posistions: white_posistions,
                             piece: piece,
                             basic_black_piece: @black_pawn,
                             basic_white_piece: @white_pawn,
                             posistion: new_posistion
                            }

          get_location_allow_all(arguments_hash)

          #allow(@board_manager).to receive(:get_location) do |args|
          #  if args == posistion
          #    piece
          #  elsif black_pawn_posistions.include?(args)
          #    @black_pawn
          #  elsif white_pawn_posistions.include?(args)
          #    @white_pawn
          #  else
          #    empty_square
          #  end
          #end
          return_cords = true
          expected = [[6,7],[5,7],[4,7],[7,6],[7,5],[7,4],[7,3],[7,2]]

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end

        it 'handles being at the edge of the board' do
          new_posistion = [7,5]
          subject.set_new_posistion(new_posistion)
          #get_location_allow_all({board_manager: @board_manager, black_posistions: black_posistions, white_posistions: white_posistions, piece: piece, basic_black_piece: @black_pawn, basic_white_piece: @white_pawn, posistion: new_posistion})
          #
          arguments_hash = { board_manager: @board_manager,
                             black_posistions: black_posistions,
                             white_posistions: white_posistions,
                             piece: piece,
                             basic_black_piece: @black_pawn,
                             basic_white_piece: @white_pawn,
                             posistion: new_posistion
                            }

          get_location_allow_all(arguments_hash)

          return_cords = true
          expected = [[7,4],[7,3],[7,2],[7,6],[7,7],[6,5],[5,5],[4,5],[3,5],[2,5],[1,5],[0,5], [2, 0], [3, 1], [4, 2], [5, 3], [6, 4]]

          expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
        end

        context 'black piece' do
          subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'black') }
          it 'works with both queen being either color' do
            

            new_posistion = [1,3]
            subject.set_new_posistion(new_posistion)
            #get_location_allow_all({board_manager: @board_manager, black_posistions: black_posistions, white_posistions: white_posistions, piece: piece, basic_black_piece: @black_pawn, basic_white_piece: @white_pawn, posistion: new_posistion})

            arguments_hash = { board_manager: @board_manager,
                              black_posistions: [[2,2],[1,0]],
                              white_posistions: [[4,6]],
                              piece: piece,
                              basic_black_piece: @black_pawn,
                              basic_white_piece: @white_pawn,
                              posistion: new_posistion
                              }

            get_location_allow_all(arguments_hash)

            return_cords = true
            expected = [[0,2],[0,3],[0,4],[1,4],[1,5],[1,6],[1,7],[2,4],[3,5],[4,6],[2,3],[3,3],[4,3],[5,3],[6,3],[7,3],[1,2],[1,1]]

            expect(subject.get_moves(@board_manager, return_cords)).to match_array(expected)
          end
        end
      end

      context 'default board' do
        before(:each) do
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
                                      #piece: piece,
                                      black_pawn: @black_pawn,
                                      white_pawn: @white_pawn,
                                      #posistion: new_posistion
                                    }
         end

        context 'white' do
          subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'white') }
          it 'd1 returns no valid moves' do
            new_posistion = [0,3]
            subject.set_new_posistion(new_posistion)
            @default_arguments_hash[:piece] = piece
            @default_arguments_hash[:posistion] = new_posistion
            get_default_board_allow(@default_arguments_hash)
            
            return_cords = true

            expect(subject.get_moves(@board_manager, return_cords)).to be_empty
          end
        end

        context 'black' do
          subject(:piece) { Piece.new(type: type, posistion: posistion, color: 'black') }
          it 'd8 returns no valid moves' do
            new_posistion = [7,3]
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