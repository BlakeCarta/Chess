class Notation
  def initialize
    # notes mostly from:
    # https://www.chess.com/terms/chess-notation
    @king = 'K'
    @queen = 'Q'
    @rook = 'R'
    @bishop = 'B'
    @knight = 'N'
    @pawn = '' # no abbreviation
    @capture = 'x'
    @promotion = '='
    @castling_kingside = "0-0"
    @castling_queenside = "0-0-0" # num of zeroes = squares the rook has moved
    @check = '+' # added to the end of the move
    @checkmate = '#' # add to the end of the move
    @white_win = "1-0"
    @black_win = "0-1"
    @draw = "1/2-1/2"
  end

  def get_special_character(text)
    # special characters indicate check/checkmate/promotion/capture
    # castling is handled in another function
    special_characters = [@check, @checkmate, @capture, @promotion]

    # check
    if text[-1] == special_characters[0]
      return special_characters[0]
    # checkmate
    elsif text[-1] == special_characters[1]
      return special_characters[1]
    # capture
    elsif text.include?(special_characters[2])
      # should this return captured piece?
      return special_characters[2]
    # promotion
    elsif text.include?(special_characters[3])
      # should also just be able to grab the last char as the desired promotion
      promotion_result = text[text.index(special_characters[3]) + 1]
      return special_characters[3], promotion_result
    end
    false
  end
end