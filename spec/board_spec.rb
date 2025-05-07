require './lib/board.rb'

describe ChessBoard do
    context '#setup_board' do
        subject(:starting_board) { described_class.new }
        it 'sets the intial correct state' do
            desired_state = [['♜','♞','♝','♛','♚','♝','♞','♜'],
                             ['♟','♟','♟','♟','♟','♟','♟','♟'],
                             ['□','■','□','■','□','■','□','■'],
                             ['■','□','■','□','■','□','■','□'],
                             ['□','■','□','■','□','■','□','■'],
                             ['■','□','■','□','■','□','■','□'],
                             ['♙','♙','♙','♙','♙','♙','♙','♙'],
                             ['♖','♘','♗','♕','♔','♗','♘','♖'],]
            expect(subject.setup_board).to eq(desired_state)
        end
    end
    
end