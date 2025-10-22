require 'piece_moves.rb'
require 'piece.rb'
class ChessBoard
  include PieceMoves
  def initialize
    @board = Array.new(8) { Array.new(8) }
    # move_history = [[start_location_alg, new_location_alg, piece],[start_location_alg, new_location_alg, piece]]
    @move_history = []
    define_piece_constants
  end
  attr_reader :board, :move_history

  def define_piece_constants
    # Unicode chess symbols, more info here: https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode
    @white_king = '♔'
    @white_queen = '♕'
    @white_rook = '♖'
    @white_bishop = '♗'
    @white_knight = '♘'
    @white_pawn = '♙'

    # WHITE_SPACE = '□' #25A1
    # BLACK_SPACE = '■' #25A0
    # From https://en.wikipedia.org/wiki/Geometric_Shapes_(Unicode_block)
    @white_space = '◻︎' # U+25FB+VS15
    @black_space = '◼︎' # U+25FC+VS15

    @black_king = '♚'
    @black_queen = '♛'
    @black_rook = '♜'
    @black_bishop = '♝'
    @black_knight = '♞'
    @black_pawn = '♟'
  end

  def setup_squares
    @board.each_with_index do |item, i|
      item.each_with_index do |_, j|
        # 1 odd = black, both = white
        if i.odd? != j.odd?
          #@board[i][j] ||= @black_space
          @board[i][j] ||= Piece.new({name: 'space', color: 'black', current_position: nil, icon: @black_space})
        else
          #@board[i][j] ||= @white_space
          @board[i][j] ||= Piece.new({name: 'space', color: 'white', current_position: nil, icon: @white_space})
        end
      end
    end
  end

  def setup_board
    setup_squares
    setup_black_pieces
    setup_white_pieces
    @board
  end

  def setup_black_pieces
    @board[0][0] = Piece.new({name: 'rook', color: 'black', current_position: ['a8', 'a8'], icon: @black_rook})
    #@board[0][0] = @black_rook
    @board[0][1] = Piece.new({name: 'knight', color: 'black', current_position: ['b8', 'b8'], icon: @black_knight})
    #@board[0][1] = @black_knight
    @board[0][2] = Piece.new({name: 'knight', color: 'black', current_position: ['c8', 'c8'], icon: @black_bishop})
    #@board[0][2] = @black_bishop
    @board[0][3] = Piece.new({name: 'queen', color: 'black', current_position: ['d8', 'd8'], icon: @black_queen})
    #@board[0][3] = @black_queen
    @board[0][4] = Piece.new({name: 'king', color: 'black', current_position: ['e8', 'e8'], icon: @black_king})
    #@board[0][4] = @black_king
    @board[0][5] = Piece.new({name: 'bishop', color: 'black', current_position: ['f8', 'f8'], icon: @black_bishop})
    #@board[0][5] = @black_bishop
    @board[0][6] = Piece.new({name: 'knight', color: 'black', current_position: ['g8', 'g8'], icon: @black_knight})
    #@board[0][6] = @black_knight
    @board[0][7] = Piece.new({name: 'rook', color: 'black', current_position: ['h8', 'h8'], icon: @black_rook})
    #@board[0][7] = @black_rook

    num_to_col = ['a','b','c','d','e','f','g','h']
    8.times { |i| @board[1][i] = Piece.new({name: 'pawn', color: 'black', current_position: ["#{num_to_col[i]}7", "#{num_to_col[i]}7"], icon: @black_pawn}) }
  end

  def setup_white_pieces
    @board[7][0] = Piece.new({name: 'rook', color: 'white', current_position: ['a1', 'a1'], icon: @white_rook})
    #@board[7][0] = @white_rook
    @board[7][1] = Piece.new({name: 'knight', color: 'white', current_position: ['b1', 'b1'], icon: @white_knight})
    #@board[7][1] = @white_knight
    @board[7][2] = Piece.new({name: 'bishop', color: 'white', current_position: ['c1', 'c1'], icon: @white_bishop})
    #@board[7][2] = @white_bishop
    @board[7][3] = Piece.new({name: 'queen', color: 'white', current_position: ['d1', 'd1'], icon: @white_queen})
    #@board[7][3] = @white_queen
    @board[7][4] = Piece.new({name: 'king', color: 'white', current_position: ['e1', 'e1'], icon: @white_king})
    #@board[7][4] = @white_king
    @board[7][5] = Piece.new({name: 'bishop', color: 'white', current_position: ['f1', 'f1'], icon: @white_bishop})
    #@board[7][5] = @white_bishop
    @board[7][6] = Piece.new({name: 'knight', color: 'white', current_position: ['g1', 'g1'], icon: @white_knight})
    #@board[7][6] = @white_knight
    @board[7][7] = Piece.new({name: 'rook', color: 'white', current_position: ['h1', 'h1'], icon: @white_rook})
    #@board[7][7] = @white_rook

    num_to_col = ['a','b','c','d','e','f','g','h']
    8.times { |i| @board[6][i] = Piece.new({name: 'pawn', color: 'white', current_position: ["#{num_to_col[i]}2", "#{num_to_col[i]}2"], icon: @white_pawn}) }
  end

  def print_board
    8.times do |i|
      puts '   -----------------------------------------' if i.zero?
      print " #{8 - i} | "
      print @board[i].each { |each| each.icon }.join('  | ')
      puts '  | '
      puts '   -----------------------------------------'
    end
    puts '     A    B    C    D    E    F    G    H'
  end

  def get_row_column(location)
    #row = location[0]
    #col = location[1]
    @board[location[0]][location[1]]
  end

  def set_row_column(location, piece)
    #row = location[0]
    #col = location[1]
    @board[location[0]][location[1]] = piece
  end

  def move_piece(start_location, new_location, piece)
    piece_to_move = get_row_column(start_location) 
    return nil if piece_to_move.nil? || piece.nil?
    return nil if piece_to_move.name != piece.name
    start_location_alg = Notation.new.row_col_to_alg(start_location) 
    new_location_alg = Notation.new.row_col_to_alg(new_location)
    moves = get_moves(start_location, piece, self)
    if moves.include?(new_location_alg)
      set_row_column(new_location, piece)
      set_row_column(start_location, nil)
      piece_to_move.current_position = new_location_alg
      setup_squares
      @move_history.append([start_location_alg, new_location_alg, piece])
      return true
    end
    false
  end
end
