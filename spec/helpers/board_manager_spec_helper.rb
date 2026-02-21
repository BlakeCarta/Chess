module BOARD_MANAGER_HELPER
  
  #@basic_black_piece = RSpec.instance_double('Piece', name: '', color: 'black')
  #@basic_white_piece = RSpec.instance_double('Piece', name: '', color: 'white')

  #@args = {board_manager:, black_posistions:, white_posistions:, piece:, basic_black_piece:, basic_white_piece:}

  # needs board_manager, piece, black_posisitions, white_posistion, black_piece, white_piece
  def get_location_allow_all(args = {})
    @empty_square = 'x'
    allow(args[:board_manager]).to receive(:get_location) do |current_posistion|
      if current_posistion == args[:piece].get_posistion
        args[:piece]
      elsif args[:black_posistions].include?(current_posistion)
        args[:basic_black_piece]
      elsif args[:white_posistions].include?(current_posistion)
        args[:basic_white_piece]
      else
        @empty_square
      end
    end
  end

  # pawn, king, queen, rook, bishop, knight
  # black_pawns = [[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7]]
  # white_pawns = [[1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7]]
  # white_rooks = [[0,0],[0,7]]
  # black_rooks = [[7,7],[7,0]]
  # white_knights = [[0,1],[0,6]]
  # black_knights = [[7,1],[7,6]]
  # white_bishops = [[0,2],[0,5]]
  # black_bishops = [[7,2],[7,5]]
  # white_queen = [[0,3]]
  # black_queen = [[7,3]]
  # white_king = [[0,4]]
  # black_king = [[7,4]]
  def get_default_board_allow(args = {})
    @empty_square = 'x'
    black_pawns = [[6,0],[6,1],[6,2],[6,3],[6,4],[6,5],[6,6],[6,7]]
    white_pawns = [[1,0],[1,1],[1,2],[1,3],[1,4],[1,5],[1,6],[1,7]]
    white_rooks = [[0,0],[0,7]]
    black_rooks = [[7,7],[7,0]]
    white_knights = [[0,1],[0,6]]
    black_knights = [[7,1],[7,6]]
    white_bishops = [[0,2],[0,5]]
    black_bishops = [[7,2],[7,5]]
    white_queen = [[0,3]]
    black_queen = [[7,3]]
    white_king = [[0,4]]
    black_king = [[7,4]]

    # rewrite this later
    allow(args[:board_manager]).to receive(:get_location) do |current_posistion|
      if current_posistion == args[:piece].get_posistion
        args[:piece]
      elsif black_pawns.include?(current_posistion)
        args[:black_pawn]
      elsif white_pawns.include?(current_posistion)
        args[:white_pawn]
      elsif black_rooks.include?(current_posistion)
        args[:black_rook]
      elsif white_rooks.include?(current_posistion)
        args[:white_rook]
      elsif black_knights.include?(current_posistion)
        args[:black_knight]
      elsif white_knights.include?(current_posistion)
        args[:white_knight]
      elsif black_bishops.include?(current_posistion)
        args[:black_bishop]
      elsif white_bishops.include?(current_posistion)
        args[:white_bishop]
      elsif black_queen.include?(current_posistion)
        args[:black_queen]
      elsif white_queen.include?(current_posistion)
        args[:white_queen]
      elsif black_king.include?(current_posistion)
        args[:black_king]
      elsif white_king.include?(current_posistion)
        args[:white_king]
      else
        @empty_square
      end
    end
  end

  def get_location_allow_empty(args = {})
    @empty_square = 'x'
    allow(args[:board_manager]).to receive(:get_location) {@empty_square}
  end
end
