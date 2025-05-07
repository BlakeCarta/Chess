class ChessBoard
  def initialize
    @board = Array.new(8) { Array.new(8) }
    define_piece_constants
  end
  attr_reader :board

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

  def setup_board
    @board.each_with_index do |item, i|
      item.each_with_index do |_, j|
        # 1 odd = black, both = white
        if i.odd? != j.odd?
          @board[i][j] = @black_space
        else
          @board[i][j] = @white_space
        end
      end
    end
    setup_black_pieces
    setup_white_pieces
    @board
  end

  def setup_black_pieces
    @board[0][0] = @black_rook
    @board[0][1] = @black_knight
    @board[0][2] = @black_bishop
    @board[0][3] = @black_queen
    @board[0][4] = @black_king
    @board[0][5] = @black_bishop
    @board[0][6] = @black_knight
    @board[0][7] = @black_rook

    8.times { |i| @board[1][i] = @black_pawn }
  end

  def setup_white_pieces
    @board[7][0] = @white_rook
    @board[7][1] = @white_knight
    @board[7][2] = @white_bishop
    @board[7][3] = @white_queen
    @board[7][4] = @white_king
    @board[7][5] = @white_bishop
    @board[7][6] = @white_knight
    @board[7][7] = @white_rook

    8.times { |i| @board[6][i] = @white_pawn }
  end

  def print_board
    8.times do |i|
      puts '   -----------------------------------------' if i.zero?
      print " #{8 - i} | "
      print @board[i].join('  | ')
      puts '  | '
      puts '   -----------------------------------------'
    end
    puts '     A    B    C    D    E    F    G    H'
  end
end
