require_relative 'player'
class AiPlayer < Player
  def initialize(board_manager = nil)
    @board_manager_ref = board_manager
    @name = 'Computer'
    @random_turn = false
  end

  attr_accessor :board_manager_ref

  # all functions should return [start_pos, end_pos]
  def make_move
    if in_check?
      # Should always be able to get out of check
      get_out_of_check
    elsif random_turn?
      get_random_piece
    else
      get_furthest_forward
    end
  end

  def get_furthest_forward
    moves = []
    i = 0
    all_friendly_pieces = get_all_friendly_pieces
    while moves.empty? && i < 10
      i += 10
      # ascending
      choice = all_friendly_pieces.sort_by { |cord| cord[0] }.last
      choice_piece = @board_manager_ref.get_location(choice)
      next if choice_piece.is_a?(String)

      potential_moves = choice_piece.get_moves(@board_manager_ref)
      moves = [choice, potential_moves.last] unless potential_moves.nil?
    end
    moves.empty? ? nil : moves
  end

  def get_random_piece
    moves = []
    i = 0
    all_friendly_pieces = get_all_friendly_pieces
    while moves.empty? && i < 10
      i += 1
      choice = all_friendly_pieces.sample
      potential_moves = @board_manager_ref.get_location(choice).get_moves(@board_manager_ref)
      # return format is location(choice in this case), and a destination it can move to
      moves = [choice, potential_moves.sample] unless potential_moves.nil?
    end
    moves.empty? ? nil : moves
  end

  def in_check?
    king_location = find_king

    update_threats

    @threatend_squares.include?([king_location])
  end

  def get_out_of_check
    threat_info = find_check_threat
    piece_to_move = find_piece_to_stop_check(threat_info)

    move_piece(piece_to_move[:piece_location], piece_to_move[:destination])
  end

  private

  def random_turn?
    if @random_turn == false
      @random_turn = true
      false
    else
      @random_turn = false
      true
    end
  end

  def move_piece(piece_to_move, destination)
    # placeholder function to return the move to the game
    [piece_to_move, destination]
  end

  def can_intercept_threat?(moves, threat_info)
    moves.any? { |move| threat_info[:threat_spaces].include?(move) }
  end

  def get_intercept_destination(moves, threat_info)
    moves.select { |move| threat_info[:threat_spaces].include?(move) }
  end

  def find_piece_to_stop_check(threat_info)
    king_location = find_king
    get_all_friendly_pieces.map do |piece_location|
      piece_ref = @board_manager_ref.get_location(piece_location)
      next if piece_ref.is_a?(String)

      moves = piece_ref.get_moves(@board_manager_ref)
      # check if the threat itself can be eliminated, if so make that move
      if piece_location != king_location
        if moves.include?(threat_info[:threat_origin])
          unless destination.nil?
            return { piece_location: piece_location,
                     destination: threat_info[:threat_origin] }
          end
        elsif can_intercept_threat?(moves, threat_info)
          destination = get_intercept_destination(moves, threat_info)

          unless destination.nil?
            return { piece_location: piece_location,
                     destination: destination }
          end
        elsif can_block_threat?(moves, threat_info)
          destination = get_block_destination(moves)

          unless destination.nil?
            return { piece_location: piece_location,
                     destination: destination }
          end
        end
      elsif can_king_escape_threat?
        destination = get_king_escape_destination

        unless destination.nil?
          return { piece_location: piece_location,
                   destination: destination }
        end
      elsif destination.nil? && moves.include?(threat_info[:threat_origin])
        # if king can kill the threat do so instead
        return { piece_location: piece_location,
                 destination: threat_info[:threat_origin] }

      end
    end
  end

  def can_block_threat?(moves, threat_info)
    !get_block_destination(moves, threat_info).nil?
  end

  def get_block_destination(moves, threat_info)
    destinations = []

    threat_info[:threat_origin]
    threat_info[:threat_spaces]

    moves.select do |move|
      location = @board_manager_ref.get_location(move)
      if (threat_info[:threat_spaces].include?(move) || threat_info[:threat_origin] == move) && (location.is_a?(String) || location.color != color)
        destinations << move
      end
    end

    destinations.empty? ? destinations.first : nil
  end

  def can_king_escape_threat?
    !get_king_escape_destination.nil?
  end

  def get_king_escape_destination
    threats = @board_manager_ref.get_threatend_squares(color)
    king = @board_manager_ref.get_location(find_king)
    # king = find_king
    destinations = []
    king.get_moves(@board_manager_ref).map do |move|
      location = @board_manager_ref.get_location(move)
      destinations << move if !threats.include?(move) && (location.is_a?(String) || location.color != color)
    end
    destinations.empty? ? nil : destinations.first
  end

  # returns the threating piece that can attack the most spaces
  def find_check_threat
    king_location = find_king
    all_threats = []
    @board_manager_ref.get_board.each_with_index do |row, index|
      row.each_with_index do |square, col_index|
        next if square.is_a?(String)
        next if square.color == color

        threat_spaces = square.get_moves(@board_manager_ref)
        if threat_spaces.include?(king_location)
          all_threats << { threat_spaces: threat_spaces, king_location: king_location,
                           threat_origin: [index, col_index] }
        end
      end
    end
    # ascending order
    all_threats.empty? ? nil : all_threats.sort_by { |threat_info| threat_info[:threat_spaces].size }.last
  end

  def update_threats
    # pass our color to threatend squares
    @threatend_squares = @board_manager_ref.get_threatend_squares(color)
  end

  def find_king
    @board_manager_ref.find_piece(color, 'king')
  end

  def get_all_friendly_pieces
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
