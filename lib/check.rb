module CHECK
  extend self

  def move_piece(piece_to_move, destination)
    # placeholder function to return the move to the game
    [piece_to_move, destination]
  end

  def in_check?(board_ref, friendly_color)
    king_location = find_king(board_ref, friendly_color)

    threatend_squares = update_threats(board_ref, friendly_color)

    threatend_squares.include?([king_location])
  end

  def get_out_of_check(board_ref, color)
    threat_info = find_check_threat(board_ref, color)
    piece_to_move = find_piece_to_stop_check(threat_info, board_ref, color)

    move_piece(piece_to_move[:piece_location], piece_to_move[:destination])
  end

  def can_block_threat?(moves, threat_info, board_ref, color)
    !get_block_destination(moves, threat_info, board_ref, color).nil?
  end

  def get_block_destination(moves, threat_info, board_ref, color)
    destinations = []

    threat_info[:threat_origin]
    threat_info[:threat_spaces]

    moves.select do |move|
      location = board_ref.get_location(move)
      if (threat_info[:threat_spaces].include?(move) || threat_info[:threat_origin] == move) && (location.is_a?(String) || location.color != color)
        destinations << move
      end
    end

    destinations.empty? ? destinations.first : nil
  end

  def can_king_escape_threat?(board_ref, color)
    !get_king_escape_destination(board_ref, color).nil?
  end

  def get_king_escape_destination(board_ref, color)
    threats = board_ref.get_threatend_squares(color)
    king = board_ref.get_location(find_king(board_ref, color))
    # king = find_king
    destinations = []
    king.get_moves(board_ref).map do |move|
      location = board_ref.get_location(move)
      destinations << move if !threats.include?(move) && (location.is_a?(String) || location.color != color)
    end
    destinations.empty? ? nil : destinations.first
  end

  def find_piece_to_stop_check(threat_info, board_ref, color)
    king_location = find_king(board_ref, color)
    get_all_friendly_pieces(board_ref, color).map do |piece_location|
      piece_ref = board_ref.get_location(piece_location)
      next if piece_ref.is_a?(String)

      moves = piece_ref.get_moves(board_ref)
      # check if the threat itself can be eliminated, if so make that move
      if piece_location != king_location
        if moves.include?(threat_info[:threat_origin])
          # destination? did I mean threat info?
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
        elsif can_block_threat?(moves, threat_info, board_ref, color)
          destination = get_block_destination(moves, threat_info, board_ref, color)

          unless destination.nil?
            return { piece_location: piece_location,
                     destination: destination }
          end
        end
      elsif can_king_escape_threat?(board_ref, color)
        destination = get_king_escape_destination(board_ref, color)

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

  def get_all_friendly_pieces(board_ref, color)
    potential_pieces = []
    board_ref.get_board.each_with_index do |row, index|
      row.each_with_index do |square, col_index|
        next if square == 'x'
        next if square.color != color

        potential_pieces << [index, col_index]
      end
    end
    potential_pieces
  end

  def can_intercept_threat?(moves, threat_info)
    moves.any? { |move| threat_info[:threat_spaces].include?(move) }
  end

  def get_intercept_destination(moves, threat_info)
    moves.select { |move| threat_info[:threat_spaces].include?(move) }
  end

  # returns the threating piece that can attack the most spaces
  def find_check_threat(board_ref, color)
    king_location = find_king(board_ref, color)
    all_threats = []
    board_ref.get_board.each_with_index do |row, index|
      row.each_with_index do |square, col_index|
        next if square.is_a?(String)
        next if square.color == color

        threat_spaces = square.get_moves(board_ref)
        if threat_spaces.include?(king_location)
          all_threats << { threat_spaces: threat_spaces, king_location: king_location,
                           threat_origin: [index, col_index] }
        end
      end
    end
    # ascending order
    all_threats.empty? ? nil : all_threats.sort_by { |threat_info| threat_info[:threat_spaces].size }.last
  end

  def find_king(board_ref, color)
    board_ref.find_piece(color, 'king')
  end

  def update_threats(board_ref, color)
    # pass our color to threatend squares
    threatend_squares = board_ref.get_threatend_squares(color)
  end
end
