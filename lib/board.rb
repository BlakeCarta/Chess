class ChessBoard
  def initialize
    @board = Array.new(8) {Array.new(8)}
    define_piece_constants
  end
  attr_reader :board

  def define_piece_constants
    # Unicode chess symbols, more info here: https://en.wikipedia.org/wiki/Chess_symbols_in_Unicode
    @WHITE_KING = '♔'
    @WHITE_QUEEN ='♕'
    @WHITE_ROOK = '♖'
    @WHITE_BISHOP = '♗'
    @WHITE_KNIGHT = '♘'
    @WHITE_PAWN = '♙'

    #WHITE_SPACE = '□' #25A1
    #BLACK_SPACE = '■' #25A0
    # From https://en.wikipedia.org/wiki/Geometric_Shapes_(Unicode_block)
    @WHITE_SPACE = '◻︎' #U+25FB+VS15
    @BLACK_SPACE = '◼︎' #U+25FC+VS15

    @BLACK_KING = '♚'
    @BLACK_QUEEN = '♛'
    @BLACK_ROOK = '♜'
    @BLACK_BISHOP = '♝'
    @BLACK_KNIGHT = '♞'
    @BLACK_PAWN = '♟'
  end

  def setup_board
    @board.each_with_index do |item, i|
      item.each_with_index do |space, j|
        # even/odd = black, both = white
        if ((i % 2 != 0) != (j % 2 != 0))
          @board[i][j] = @BLACK_SPACE
        else
          @board[i][j] = @WHITE_SPACE
        end
      end
    end
    
    setup_black_pieces
    setup_white_pieces

    @board
  end

  def setup_black_pieces
    @board[0][0] = @BLACK_ROOK
    @board[0][1] = @BLACK_KNIGHT
    @board[0][2] = @BLACK_BISHOP
    @board[0][3] = @BLACK_QUEEN
    @board[0][4] = @BLACK_KING
    @board[0][5] = @BLACK_BISHOP
    @board[0][6] = @BLACK_KNIGHT
    @board[0][7] = @BLACK_ROOK

    8.times do |i|
      @board[1][i] = @BLACK_PAWN
    end
  end

  def setup_white_pieces
    @board[7][0] = @WHITE_ROOK
    @board[7][1] = @WHITE_KNIGHT
    @board[7][2] = @WHITE_BISHOP
    @board[7][3] = @WHITE_QUEEN
    @board[7][4] = @WHITE_KING
    @board[7][5] = @WHITE_BISHOP
    @board[7][6] = @WHITE_KNIGHT
    @board[7][7] = @WHITE_ROOK

    8.times do |i|
      @board[6][i] = @WHITE_PAWN
    end
  end

  def print_board
    8.times do |i|
      puts "   -----------------------------------------" if i == 0
      print " #{8-i} | "
      #print @board[i].join("\u2003".encode('utf-8'))
      print @board[i].join('  | ')
      puts '  | '
      puts "   -----------------------------------------"
    end
    puts "     A    B    C    D    E    F    G    H"
  end
end