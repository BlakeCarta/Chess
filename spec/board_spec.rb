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
    
    context '#print_board' do
        subject(:starting_board) { described_class.new }
        xit 'corretly prints the starting board' do
            expected_start_output = ''
            expect(subject.print_board).to eq(expected_start_output)
        end
    end
end