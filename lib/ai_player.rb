require_relative 'player'
class AiPlayer < Player
  def make_move(board_manager_ref)
    # Alternate b/w the furtherest forward piece and a random one
    # 1st turn starts with a pawn
    # 2nd turn random
    # 3rd Most forward piece
    # 4th random
    #
    # Allow for check/checkmate checks to eliminate moves
    # Allow for check/checkmate to become the move
    # Of all moves generated select a random one
    # no need for a more complicated algo
    #
    # Well checkmate ends game, so only need to validate checks
    #
    if in_check?
      get_out_of_check
    elsif random_turn?
      get_random_piece
    else
      get_furthest_forward
    end
  end

  def in_check?
    king_location = find_king

    update_threats

    @threatend_squares.include?(king_location)
  end

  private

  def move_piece(piece_to_move, destination)
    [piece_to_move, destination]
  end

  def get_out_of_check
    threat_info = find_check_threat
    piece_to_move = find_piece_to_stop_check(threat_info)

    # not sure if this logic pans out, like it might need to move to block
    # this assumes it can only move to destroy
    move_piece(piece_to_move[:piece_location], threat_info[:threat_origin])
  end

  def find_piece_to_stop_check(threat_info)
    get_all_pieces.map do |piece_location|
      moves = @board_manager_ref.get_location(piece_location).get_moves(@board_manager_ref)
      return { piece_location: piece_location, threat_info: threat_info } if moves.include?(threat_info[:threat_origin])
    end
  end

  def find_check_threat
    king_location = find_king
    @board_manager_ref.get_board.each_with_index do |row, index|
      row.each_with_index do |square, col_index|
        next if square.is_a?(String)
        next if square.color != color

        threat_spaces = square.get_moves(@board_manager_ref)
        if threat_spaces.include?(king_location)
          return { threat_spaces: threat_spaces, king_location: king_location, threat_origin: [index, col_index] }
        end
      end
    end
  end

  def update_threats
    # pass our color to threatend squares
    @threatend_squares = @board_manager_ref.get_threatend_squares(color)
  end

  def find_king
    @board_manager_ref.get_board.each_with_index do |row, index|
      row.each_with_index do |square, col_index|
        next if square == 'x'
        next if square.color != color

        # potential_pieces << [index, col_index]
        return [index, col_index] if name == 'king'
      end
    end
  end

  def get_all_pieces
    potential_pieces = []
    @board_manager_ref.get_board.each_with_index do |row, index|
      row.each_with_index do |square, col_index|
        next if square == 'x'
        next if square.color != color

        potential_pieces << [index, col_index]
      end
    end
    potential_pieces
  end
end
