require_relative 'generic_piece.rb'
require_relative 'piece_functions.rb'

class Piece
  include Piece_functions

  def initialize(type:, posistion:, color:)
    @root = case type
            when 'pawn'
              make_pawn(type, posistion, color)
            when 'knight'
              make_knight(type, posistion, color)
            when 'queen'
              make_queen(type, posistion, color)
            when 'rook'
              make_rook(type, posistion, color)
            when 'bishop'
              make_bishop(type, posistion, color)
            when 'king'
              make_king(type, posistion, color)
            else
              nil
            end

    @root.set_move_list(@moves)
  end
end