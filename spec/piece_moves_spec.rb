require './lib/board.rb'
require './lib/piece_moves.rb'
require './lib/notation.rb'
describe Piece do
  context 'first_example_game' do
    game_board_one = ChessBoard.new
    game_board_one.setup_squares
    game_board_one.set_row_column(Notation.new().alg_to_row_col('a8'), Piece.new(name: 'rook', color: 'black', current_position: 'a8', icon: '♜'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('b8'), Piece.new(name: 'knight', color: 'black', current_position: Notation.new().alg_to_row_col('b8'), icon: '♞'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('d8'), Piece.new(name: 'queen', color: 'black', current_position: Notation.new().alg_to_row_col('d8'), icon: '♛'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('e8'), Piece.new(name: 'king', color: 'black', current_position: 'e8', icon: '♚'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('h8'), Piece.new(name: 'rook', color: 'black', current_position: 'h8', icon: '♜'))

    game_board_one.set_row_column(Notation.new().alg_to_row_col('c7'), Piece.new(name: 'pawn', color: 'black', current_position: Notation.new().alg_to_row_col('c7'), icon: '♟'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('d7'), Piece.new(name: 'pawn', color: 'black', current_position: Notation.new().alg_to_row_col('d7'), icon: '♟'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('f7'), Piece.new(name: 'pawn', color: 'black', current_position: Notation.new().alg_to_row_col('f7'), icon: '♟'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('g7'), Piece.new(name: 'pawn', color: 'black', current_position: Notation.new().alg_to_row_col('g7'), icon: '♟'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('h7'), Piece.new(name: 'pawn', color: 'black', current_position: Notation.new().alg_to_row_col('h7'), icon: '♟'))

    game_board_one.set_row_column(Notation.new().alg_to_row_col('a6'), Piece.new(name: 'bishop', color: 'black', current_position: Notation.new().alg_to_row_col('a6'), icon: '♝'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('b6'), Piece.new(name: 'pawn', color: 'black', current_position: Notation.new().alg_to_row_col('b6'), icon: '♟'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('e6'), Piece.new(name: 'pawn', color: 'black', current_position: Notation.new().alg_to_row_col('e6'), icon: '♟'))

    game_board_one.set_row_column(Notation.new().alg_to_row_col('d4'), Piece.new(name: 'pawn', color: 'white', current_position: Notation.new().alg_to_row_col('d4'), icon: '♙', original_position: 'd2'))

    game_board_one.set_row_column(Notation.new().alg_to_row_col('a3'), Piece.new(name: 'pawn', color: 'white', current_position: Notation.new().alg_to_row_col('a3'), icon: '♙'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('d3'), Piece.new(name: 'bishop', color: 'white', current_position: Notation.new().alg_to_row_col('d3'), icon: '♗'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('e3'), Piece.new(name: 'pawn', color: 'white', current_position: Notation.new().alg_to_row_col('e3'), icon: '♙'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('f3'), Piece.new(name: 'knight', color: 'white', current_position: Notation.new().alg_to_row_col('f3'), icon: '♘'))

    game_board_one.set_row_column(Notation.new().alg_to_row_col('e2'), Piece.new(name: 'king', color: 'white', current_position: 'e2', icon: '♔'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('f2'), Piece.new(name: 'pawn', color: 'white', current_position: Notation.new().alg_to_row_col('f2'), icon: '♙'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('g2'), Piece.new(name: 'pawn', color: 'white', current_position: Notation.new().alg_to_row_col('g2'), icon: '♙', original_position: 'g2'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('h2'), Piece.new(name: 'pawn', color: 'white', current_position: Notation.new().alg_to_row_col('h2'), icon: '♙'))

    game_board_one.set_row_column(Notation.new().alg_to_row_col('a1'), Piece.new(name: 'bishop', color: 'black', current_position: Notation.new().alg_to_row_col('a1'), icon: '♝'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('b1'), Piece.new(name: 'knight', color: 'white', current_position: Notation.new().alg_to_row_col('b1'), icon: '♘'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('c1'), Piece.new(name: 'bishop', color: 'white', current_position: Notation.new().alg_to_row_col('c1'), icon: '♗'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('d1'), Piece.new(name: 'queen', color: 'white', current_position: Notation.new().alg_to_row_col('d1'), icon: '♕'))
    game_board_one.set_row_column(Notation.new().alg_to_row_col('h1'), Piece.new(name: 'rook', color: 'white', current_position: 'h1', icon: '♖'))

    subject(:game_one) { described_class.new() }
    context '#rook_move' do
      location = 'h1'
      expected_rook_moves = ['e1','f1','g1']

      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_one.rook_move(location, :game_one, game_board_one)).to match_array(expected_rook_moves)
      end
    end

    context '#bishop_move' do
      location = 'd3'
      expected_bishop_moves = ['e4','f5','g6','h7','c2','c4','b5','a6']
      # a6 is a capture
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_one.bishop_move(location, :game_one, game_board_one)).to match_array(expected_bishop_moves)
      end
    end

    context '#knight_move' do
      context 'knight at b1' do
        location = 'b1'
        expected_knight_moves = ['c3','d2']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_one.knight_move(location, :game_one, game_board_one)).to match_array(expected_knight_moves)
        end
      end
      
      context 'knight at f3' do
        # 2nd knight test
        location = 'f3'
        expected_knight_moves = ['d2','e1','e5','g1','g5','h4']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_one.knight_move(location, :game_one, game_board_one)).to match_array(expected_knight_moves)
        end
      end
    end

    context '#king_move' do
      location = 'e2'
      expected_king_moves = ['d2','e1','f1']
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_one.king_move(location, :game_one, game_board_one)).to match_array(expected_king_moves)
      end
    end

    context '#queen_move' do
      location = 'd1'
      expected_queen_moves = ['a4','b3','c2','d2','e1','f1','g1']
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_one.queen_move(location, :game_one, game_board_one)).to match_array(expected_queen_moves)
      end
    end

    context '#pawn_move' do
      context 'pawn 1' do
        location = 'g2'
        expected_pawn_moves = ['g3','g4']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_one.pawn_move(location, :game_one, game_board_one)).to match_array(expected_pawn_moves)
        end
      end

      context 'pawn 2' do
        # 2nd pawn
        location = 'd4'
        expected_pawn_moves = ['d5']
        location = Notation.new.alg_to_row_col(location)
        it 'returns the correct moves' do
          expect(game_one.pawn_move(location, :game_one, game_board_one)).to match_array(expected_pawn_moves)
        end
      end
    end
  end

  context 'second_example_game' do
    game_board_two = ChessBoard.new
    game_board_two.setup_squares

    game_board_two.set_row_column(Notation.new().alg_to_row_col('a8'), Piece.new(name: 'rook', color: 'black', current_position: 'a8', icon: '♜'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('b8'), Piece.new(name: 'knight', color: 'black', current_position: 'b8', icon: '♞'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('c8'), Piece.new(name: 'bishop', color: 'black', current_position: 'c8', icon: '♝'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('d8'), Piece.new(name: 'queen', color: 'black', current_position: 'd8', icon: '♛'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('e8'), Piece.new(name: 'king', color: 'black', current_position: 'e8', icon: '♚'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('f8'), Piece.new(name: 'bishop', color: 'black', current_position: 'f8', icon: '♝'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('h8'), Piece.new(name: 'rook', color: 'black', current_position: 'h8', icon: '♜'))

    game_board_two.set_row_column(Notation.new().alg_to_row_col('a7'), Piece.new(name: 'pawn', color: 'black', current_position: 'a7', icon: '♟'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('b7'), Piece.new(name: 'pawn', color: 'black', current_position: 'b7', icon: '♟'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('e7'), Piece.new(name: 'pawn', color: 'black', current_position: 'e7', icon: '♟'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('h7'), Piece.new(name: 'pawn', color: 'black', current_position: 'h7', icon: '♟'))

    game_board_two.set_row_column(Notation.new().alg_to_row_col('c6'), Piece.new(name: 'pawn', color: 'black', current_position: 'c6', icon: '♟'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('f6'), Piece.new(name: 'pawn', color: 'black', current_position: 'f6', icon: '♟'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('g6'), Piece.new(name: 'pawn', color: 'black', current_position: 'g6', icon: '♟'))

    game_board_two.set_row_column(Notation.new().alg_to_row_col('d5'), Piece.new(name: 'pawn', color: 'black', current_position: 'd5', icon: '♟'))

    game_board_two.set_row_column(Notation.new().alg_to_row_col('b4'), Piece.new(name: 'pawn', color: 'white', current_position: 'b4', icon: '♙'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('d4'), Piece.new(name: 'pawn', color: 'white', current_position: 'd4', icon: '♙'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('f4'), Piece.new(name: 'pawn', color: 'white', current_position: 'f4', icon: '♙'))

    game_board_two.set_row_column(Notation.new().alg_to_row_col('c3'), Piece.new(name: 'knight', color: 'black', current_position: 'c3', icon: '♞'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('d3'), Piece.new(name: 'bishop', color: 'white', current_position:'d3', icon: '♗'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('e3'), Piece.new(name: 'pawn', color: 'white', current_position: 'e3', icon: '♙'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('f3'), Piece.new(name: 'knight', color: 'white', current_position: 'f3', icon: '♘'))

    game_board_two.set_row_column(Notation.new().alg_to_row_col('a2'), Piece.new(name: 'pawn', color: 'white', current_position: 'a2', icon: '♙'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('c2'), Piece.new(name: 'pawn', color: 'white', current_position: 'c2', icon: '♙'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('d2'), Piece.new(name: 'knight', color: 'white', current_position: 'd2', icon: '♘'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('g2'), Piece.new(name: 'pawn', color: 'white', current_position: 'g2', icon: '♙', original_position: 'g2'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('h2'), Piece.new(name: 'pawn', color: 'white', current_position: 'h2', icon: '♙'))

    game_board_two.set_row_column(Notation.new().alg_to_row_col('a1'), Piece.new(name: 'rook', color: 'white', current_position: 'a1', icon: '♖'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('c1'), Piece.new(name: 'bishop', color: 'white', current_position: 'c1', icon: '♗'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('d1'), Piece.new(name: 'queen', color: 'white', current_position: 'd1', icon: '♕', original_position: 'd1'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('e1'), Piece.new(name: 'king', color: 'white', current_position: 'e1', icon: '♔'))
    game_board_two.set_row_column(Notation.new().alg_to_row_col('h1'), Piece.new(name: 'rook', color: 'white', current_position: 'h1', icon: '♖'))

    subject(:game_two) { described_class.new() }
    context '#rook_move' do
      location = 'h1'
      expected_rook_moves = ['f1','g1']

      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_two.rook_move(location, :game_two, game_board_two)).to match_array(expected_rook_moves)
      end
    end

    context '#bishop_move' do
      context 'bishop 1' do
        location = 'd3'
        expected_bishop_moves = ['a6','b5','c4','e2','e4','f1','f5','g6']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.bishop_move(location, :game_two, game_board_two)).to match_array(expected_bishop_moves)
        end
      end

      context 'bishop 2' do
        location = 'c1'
        expected_bishop_moves = ['b2','a3']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.bishop_move(location, :game_two, game_board_two)).to match_array(expected_bishop_moves)
        end
      end
    end

    context '#knight_move' do
      context 'knight 1' do
        location = 'f3'
        expected_knight_moves = ['e5','g1','g5','h4']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.knight_move(location, :game_two, game_board_two)).to match_array(expected_knight_moves)
        end
      end

      context 'knight 2' do
        # 2nd knight test
        location = 'd2'
        expected_knight_moves = ['b1','b3','c4','e4','f1']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.knight_move(location, :game_two, game_board_two)).to match_array(expected_knight_moves)
        end
      end
    end

    context '#king_move' do
      location = 'e1'

      castle = {king_target: 'e1', rook_target: 'h1'}
      
      expected_king_moves = ['f1','f2', [{king_target: 'e1', rook_target: 'h1'}]] # g1 is castle
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_two.king_move(location, :game_two, game_board_two)).to match_array(expected_king_moves)
      end
    end

    context '#queen_move' do
      location = 'd1'
      expected_queen_moves = ['e2']
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_two.queen_move(location, :game_two, game_board_two)).to match_array(expected_queen_moves)
      end
    end

    context '#pawn_move' do
        context 'pawn 1' do
        location = 'd1'
        expected_pawn_moves = []
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.pawn_move(location, :game_two, game_board_two)).to match_array(expected_pawn_moves)
        end
      end

      # 2nd pawn
      context 'pawn 2' do
        location = 'e3'
        expected_pawn_moves = ['e4'] 
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.pawn_move(location, :game_two, game_board_two)).to match_array(expected_pawn_moves)
        end
      end

      # 3rd pawn
      context 'pawn 3' do
        location = 'f4'
        expected_pawn_moves = ['f5'] 
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.pawn_move(location, :game_two, game_board_two)).to match_array(expected_pawn_moves)
        end
      end

      # 4th pawn
      context 'pawn 4' do
        location = 'g2'
        expected_pawn_moves = ['g3','g4'] 
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_two.pawn_move(location, :game_two, game_board_two)).to match_array(expected_pawn_moves)
        end
      end
    end
  end

  context 'third_example_game' do
    # game 3 - black player
    game_board_three = ChessBoard.new
    game_board_three.setup_squares

    game_board_three.set_row_column(Notation.new().alg_to_row_col('h1'), Piece.new(name: 'rook', color: 'white', current_position: 'h1', icon: '♖'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('e1'), Piece.new(name: 'king', color: 'white', current_position: 'e1', icon: '♔'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('d1'), Piece.new(name: 'queen', color: 'white', current_position: 'd1', icon: '♕'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('c1'), Piece.new(name: 'bishop', color: 'white', current_position: 'c1', icon: '♗'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('a1'), Piece.new(name: 'rook', color: 'white', current_position: 'a1', icon: '♖'))

    game_board_three.set_row_column(Notation.new().alg_to_row_col('h2'), Piece.new(name: 'pawn', color: 'white', current_position: 'h2', icon: '♙'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('g2'), Piece.new(name: 'pawn', color: 'white', current_position: 'g2', icon: '♙'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('e2'), Piece.new(name: 'pawn', color: 'white', current_position: 'e2', icon: '♙'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('c2'), Piece.new(name: 'pawn', color: 'white', current_position: 'c2', icon: '♙'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('b2'), Piece.new(name: 'pawn', color: 'white', current_position: 'b2', icon: '♙'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('a2'), Piece.new(name: 'pawn', color: 'white', current_position: 'a2', icon: '♙'))

    game_board_three.set_row_column(Notation.new().alg_to_row_col('c3'), Piece.new(name: 'knight', color: 'white', current_position: 'c3', icon: '♘'))

    game_board_three.set_row_column(Notation.new().alg_to_row_col('e4'), Piece.new(name: 'pawn', color: 'white', current_position: 'e4', icon: '♙'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('b4'), Piece.new(name: 'knight', color: 'black', current_position: 'b4', icon: '♞'))

    game_board_three.set_row_column(Notation.new().alg_to_row_col('c5'), Piece.new(name: 'pawn', color: 'black', current_position: 'c5', icon: '♟', original_position: 'c7'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('b5'), Piece.new(name: 'bishop', color: 'white', current_position: 'b5', icon: '♗'))

    game_board_three.set_row_column(Notation.new().alg_to_row_col('f6'), Piece.new(name: 'knight', color: 'black', current_position: 'f6', icon: '♞'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('d6'), Piece.new(name: 'pawn', color: 'white', current_position: 'd6', icon: '♙'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('b6'), Piece.new(name: 'queen', color: 'black', current_position: 'b6', icon: '♛'))

    game_board_three.set_row_column(Notation.new().alg_to_row_col('h7'), Piece.new(name: 'pawn', color: 'black', current_position: 'h7', icon: '♟', original_position: 'h7'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('g7'), Piece.new(name: 'pawn', color: 'black', current_position: 'g7', icon: '♟'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('f7'), Piece.new(name: 'pawn', color: 'black', current_position: 'f7', icon: '♟'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('d7'), Piece.new(name: 'knight', color: 'white', current_position: 'd7', icon: '♘'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('b7'), Piece.new(name: 'pawn', color: 'black', current_position: 'b7', icon: '♟'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('a7'), Piece.new(name: 'pawn', color: 'black', current_position: 'a7', icon: '♟'))

    game_board_three.set_row_column(Notation.new().alg_to_row_col('h8'), Piece.new(name: 'rook', color: 'black', current_position: 'h8', icon: '♜'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('f8'), Piece.new(name: 'bishop', color: 'black', current_position: 'f8', icon: '♝'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('e8'), Piece.new(name: 'king', color: 'black', current_position: 'e8', icon: '♚'))
    game_board_three.set_row_column(Notation.new().alg_to_row_col('a8'), Piece.new(name: 'rook', color: 'black', current_position: 'a8', icon: '♜'))


    subject(:game_three) { described_class.new() }
    context '#rook_move' do
      location = 'a8'
      expected_rook_moves = ['d8','c8','b8']
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_three.rook_move(location, :game_three, game_board_three)).to match_array(expected_rook_moves)
      end
    end

    context '#bishop_move' do
      location = 'f8'
      expected_bishop_moves = ['e7','d6']
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_three.bishop_move(location, :game_three, game_board_three)).to match_array(expected_bishop_moves)
      end
    end

    context '#knight_move' do
      context 'knight 1' do
        location = 'b4'
        expected_knight_moves = ['d5','d3','c6','c2','a6','a2']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_three.knight_move(location, :game_three, game_board_three)).to match_array(expected_knight_moves)
        end
      end

      context 'knight 2' do
        location = 'f6'
        expected_knight_moves = ['h5','g8','g4','e4','d5','d7']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_three.knight_move(location, :game_three, game_board_three)).to match_array(expected_knight_moves)
        end
      end
    end

    context '#king_move' do
      location = 'e8'

      castle = {king_target: 'e8', rook_target: 'a8'}
      # c8 is a castle move
      expected_king_moves = ['d8', [{king_target: 'e8', rook_target: 'a8'}]]
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_three.king_move(location, :game_three, game_board_three)).to match_array(expected_king_moves)
      end
    end

    context '#queen_move' do
      location = 'b6'
      expected_queen_moves = ['d8','d6','c7','c6','b5','a5','a6']
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_three.queen_move(location, :game_three, game_board_three)).to match_array(expected_queen_moves)
      end
    end

    context '#pawn_move' do
      context 'pawn 1' do
        location = 'c5'
        expected_pawn_moves = ['c4']
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_three.pawn_move(location, :game_three, game_board_three)).to match_array(expected_pawn_moves)
        end
      end

      # 2nd pawn
      context 'pawn 2' do
        location = 'b7'
        expected_pawn_moves = [] 
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_three.pawn_move(location, :game_three, game_board_three)).to match_array(expected_pawn_moves)
        end
      end

      # 3rd pawn
      context 'pawn 3' do
        location = 'h7'
        expected_pawn_moves = ['h6','h5'] 
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_three.pawn_move(location, :game_three, game_board_three)).to match_array(expected_pawn_moves)
        end
      end

      # 4th pawn
      context 'pawn 4' do
        location = 'd6'
        expected_pawn_moves = [] 
        location = Notation.new.alg_to_row_col(location)

        it 'returns the correct moves' do
          expect(game_three.pawn_move(location, :game_three, game_board_three)).to match_array(expected_pawn_moves)
        end
      end
    end
  end

  context 'fourth_example_game' do
    # game 4 - white player
    # this is to handle an edge case for the pawn
    game_board_four = ChessBoard.new
    game_board_four.setup_squares

    game_board_four.set_row_column(Notation.new().alg_to_row_col('d6'), Piece.new(name: 'pawn', color: 'white', current_position: 'd6', icon: '♙', original_position: 'd2'))
    game_board_four.set_row_column(Notation.new().alg_to_row_col('d7'), Piece.new(name: 'knight', color: 'white', current_position: 'd7', icon: '♘'))
    game_board_four.set_row_column(Notation.new().alg_to_row_col('e7'), Piece.new(name: 'pawn', color: 'black', current_position: 'e7', icon: '♟', original_position: 'e7'))
    game_board_four.set_row_column(Notation.new().alg_to_row_col('c7'), Piece.new(name: 'pawn', color: 'black', current_position: 'c7', icon: '♟', original_position: 'c7'))

    subject(:game_four) { described_class.new() }
    context '#pawn_move' do
      location = 'd6'
      expected_pawn_moves = ['e7','c7']
      location = Notation.new.alg_to_row_col(location)

      it 'returns the correct moves' do
        expect(game_four.pawn_move(location, :game_four, game_board_four)).to match_array(expected_pawn_moves)
      end
    end
  end

  context 'fifth_example_game' do
    # game 5 - white player
    # this is to handle an edge case for the pawn
    game_board_five = ChessBoard.new
    game_board_five.setup_squares

    game_board_five.set_row_column(Notation.new().alg_to_row_col('f2'), Piece.new(name: 'pawn', color: 'white', current_position: 'f2', icon: '♙', original_position: 'f2'))
    
    game_board_five.set_row_column(Notation.new().alg_to_row_col('e7'), Piece.new(name: 'pawn', color: 'black', current_position: 'e7', icon: '♟', original_position: 'e7'))
    

    subject(:game_five) { described_class.new() }
    context '#pawn_move' do
      location = 'f5'
      
      location = Notation.new.alg_to_row_col(location)

      white_pawn_start_1 = Notation.new.alg_to_row_col('f2')
      white_pawn_end_1 = Notation.new.alg_to_row_col('f4')

      white_pawn_1 = game_board_five.get_row_column(white_pawn_start_1)
      game_board_five.move_piece(white_pawn_start_1, white_pawn_end_1, white_pawn_1)

      white_pawn_start_2 = Notation.new.alg_to_row_col('f4')
      white_pawn_end_2 = Notation.new.alg_to_row_col('f5')

      white_pawn_2 = game_board_five.get_row_column(white_pawn_start_2)
      game_board_five.move_piece(white_pawn_start_2, white_pawn_end_2, white_pawn_2)

      black_pawn_start = Notation.new.alg_to_row_col('e7')
      black_pawn_end = Notation.new.alg_to_row_col('e5')

      black_pawn = game_board_five.get_row_column(black_pawn_start)
      game_board_five.move_piece(black_pawn_start, black_pawn_end, black_pawn)

      #[start_location_alg, new_location_alg, piece]
      expected_move_history = [['f2', 'f4', white_pawn_1], ['f4', 'f5', white_pawn_2], ['e7', 'e5', black_pawn]]

      expected_pawn_moves = ['f6', {capturing_pawn: 'f5', pawn_to_be_captured: 'e5', end_position: 'e6'}]

      context 'validate move history' do
        it 'matches the expected move history' do
          expect(game_board_five.move_history).to match_array(expected_move_history)
        end
      end

      context 'en passant' do
        it 'returns the correct moves' do
          expect(game_five.pawn_move(location, :game_five, game_board_five)).to match_array(expected_pawn_moves)
        end
      end
    end
  end

    context 'sixth_example_game' do
    # game 6 - black player
    game_board_six = ChessBoard.new
    game_board_six.setup_squares

    game_board_six.set_row_column(Notation.new().alg_to_row_col('e2'), Piece.new(name: 'pawn', color: 'white', current_position: 'e2', icon: '♙', original_position: 'e2'))
    
    game_board_six.set_row_column(Notation.new().alg_to_row_col('d7'), Piece.new(name: 'pawn', color: 'black', current_position: 'd7', icon: '♟', original_position: 'd7'))

    subject(:game_six) { described_class.new() }
    context '#pawn_move' do
      location = 'd4'

      black_pawn_start_1 = Notation.new.alg_to_row_col('d7')
      black_pawn_end_1 = Notation.new.alg_to_row_col('d5')

      black_pawn_1 = game_board_six.get_row_column(black_pawn_start_1)
      game_board_six.move_piece(black_pawn_start_1, black_pawn_end_1, black_pawn_1)

      black_pawn_start_2 = Notation.new.alg_to_row_col('d5')
      black_pawn_end_2 = Notation.new.alg_to_row_col('d4')

      black_pawn_2 = game_board_six.get_row_column(black_pawn_start_2)
      game_board_six.move_piece(black_pawn_start_2, black_pawn_end_2, black_pawn_2)

      white_pawn_start_1 = Notation.new.alg_to_row_col('e2')
      white_pawn_end_1 = Notation.new.alg_to_row_col('e4')

      white_pawn_1 = game_board_six.get_row_column(white_pawn_start_1)
      game_board_six.move_piece(white_pawn_start_1, white_pawn_end_1, white_pawn_1)

      #[start_location_alg, new_location_alg, piece]
      expected_move_history = [['d7', 'd5', black_pawn_1], ['d5', 'd4', black_pawn_2], ['e2', 'e4', white_pawn_1]]

      expected_pawn_moves = ['d3', {capturing_pawn: 'd4', pawn_to_be_captured: 'e4', end_position: 'e3'}]

      location = Notation.new.alg_to_row_col(location)

      context 'validate move history' do
        it 'matches the expected move history' do
          expect(game_board_six.move_history).to match_array(expected_move_history)
        end
      end

      context 'en passant' do
        it 'returns the correct moves' do
          expect(game_six.pawn_move(location, :game_six, game_board_six)).to match_array(expected_pawn_moves)
        end
      end
    end
  end
end