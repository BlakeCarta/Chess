module PieceMoves
  def can_capture?(threatend_location, board_ref, piece_location)
    target = board_ref.get_row_column(threatend_location)
    if target.name == "space"
      return false
    end
    if target.color != board_ref.get_row_column(piece_location).color
      return true
    end
    false
  end

  def location_empty?(location, board_ref)
    # location is x,y
    target = board_ref.get_row_column(location)
    if target.name == "space"
      return true
    end
    false
  end

  def is_out_of_bounds?(location, board_ref)
    if (location[0] >= 8 || location[0] < 0) || (location[1] >= 8 || location[1] < 0)
      return true
    elsif board_ref.get_row_column(location).nil?
      return true
    else
      return false
    end
  end

  def pawn_move(location, piece, board_ref)
    #x_y
    piece_ref = board_ref.get_row_column(location)
    if piece_ref.original_position == Notation.new().row_col_to_alg(location)
      # move up 1/2 rows
      if piece_ref.color == 'white'
        move_modifier = [[-1,0],[-2,0]]
      else
        move_modifier = [[1,0],[2,0]]
      end
    else
      # move up 1 row
      if piece_ref.color == 'white'
        move_modifier = [[-1,0]]
      else
        move_modifier = [[1,0]]
      end
    end
    possible_locations = []
    possible_locations = move_modifier.map { |mod| [location[0]+mod[0], location[1]+mod[1]] }
    possible_locations.select! { |each| location_empty?(each, board_ref) }
    
    opt1 = is_out_of_bounds?([location[0] - 1, location[1] - 1], board_ref)
    opt2 = is_out_of_bounds?([location[0] - 1, location[1] + 1], board_ref)
    opt3 = is_out_of_bounds?([location[0] + 1, location[1] - 1], board_ref)
    opt4 = is_out_of_bounds?([location[0] + 1, location[1] + 1], board_ref)

    unless [opt1, opt2, opt3, opt4].any?(true)
      if piece_ref.color == 'white'
        if can_capture?([location[0] - 1, location[1] - 1], board_ref, location)
          # up 1 row, minus 1 col
          #move_modifier << [1,-1]
          possible_locations << [location[0] - 1, location[1] - 1]
        end
        # right
        if can_capture?([location[0] - 1, location[1] + 1], board_ref, location)
          # up 1 row, plus 1 col
          #move_modifier << [1,1]
          possible_locations << [location[0] - 1, location[1] + 1]
        end
      else
        # left - as viewed by black player
        if can_capture?([location[0] + 1, location[1] - 1], board_ref, location)
          # up 1 row, minus 1 col
          #move_modifier << [-1,-1]
          possible_locations << [location[0] + 1, location[1] - 1]
        end
        # right
        if can_capture?([location[0] + 1, location[1] + 1], board_ref, location)
          # up 1 row, plus 1 col
          #move_modifier << [-1,1]
          possible_locations << [location[0] + 1, location[1] + 1]
        end
      end
    end
    #possible_locations
    collection = []
    possible_locations.uniq!
    possible_locations.each do |each|
      temp = Notation.new().row_col_to_alg(each.flatten(1))
      collection << temp unless temp.nil?      
    end
    passant_moves = get_en_passant(location, board_ref)
    collection += passant_moves unless passant_moves.nil?
    collection
  end

  def recurse_line(current_location, move_modifier, board_ref, original_location)
    possible_locations = []
    return possible_locations if is_out_of_bounds?(current_location, board_ref)

    next_pos = [move_modifier[0] + current_location[0], move_modifier[1] + current_location[1]]

    if can_capture?(current_location, board_ref, original_location)
      possible_locations.append(current_location)
      return possible_locations
    elsif location_empty?(current_location, board_ref)
      possible_locations.append(current_location)
      possible_locations += recurse_line(next_pos, move_modifier, board_ref, original_location)
    end
    possible_locations
  end

  def bishop_move(location, piece, board_ref)
    move_modifier = [[1,1], [-1,1], [1,-1], [-1,-1]]
    queue = move_modifier.map { |e| [e[0] + location[0], e[1] + location[1]] }
    possible_locations = []
   

    queue.each_with_index do |e, i|
      next if (e[0] >= 8 || e[0] <= 0) || (e[1] >= 8 || e[1] <= 0) # could prolly just use the oob func
      if location_empty?(e, board_ref)
        possible_locations.append(recurse_line(e, move_modifier[i], board_ref, location))
      elsif can_capture?(e, board_ref, location)
        possible_locations.append(e)
      end
    end

    collection = []
    possible_locations.flatten(1).each do |each|
      if each.length > 2
        each.each do |e|
          temp = Notation.new().row_col_to_alg(e)
          collection << temp unless temp.nil?
        end
      else  
        temp = Notation.new().row_col_to_alg(each.flatten)
        collection << temp unless temp.nil?
      end      
    end
    collection
  end

  def knight_move(location, piece, board_ref)
    # location = row,col
    #+2row,-1col, +2row,+1col, +1row,+2col, -1row,+2col, -2row,+1col, -2row,-1col, -1row,-2col, +1row,-2col
    move_modifier = [[2,-1], [2,1], [1,2], [-1,2], [-2,1], [-2,-1], [-1,-2], [1,-2]]
    queue = move_modifier.map { |mod| [location[0]+mod[0], location[1]+mod[1]] }

    possible_locations = []
    queue.each_with_index do |e, i|
      next if is_out_of_bounds?(e, board_ref)
      if location_empty?(e, board_ref)
        possible_locations << e
      elsif can_capture?(e, board_ref, location)
        possible_locations << e
      end
    end
    collection = []
    possible_locations.each do |each|
      if each.length > 2
        each.each do |e|
          temp = Notation.new().row_col_to_alg(e)
          collection << temp unless temp.nil?
        end
      else  
        temp = Notation.new().row_col_to_alg(each)
        collection << temp unless temp.nil?
      end      
    end
    collection
  end

  def queen_move(location, piece, board_ref)
    # loc = row, col
    move_modifier = [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[-1,0],[0,-1],[1,-1]]
    queue = move_modifier.map { |e| [e[0] + location[0], e[1] + location[1]] }
    possible_locations = []
    queue.each_with_index do |e, i|
      next if is_out_of_bounds?(e, board_ref)
      if location_empty?(e, board_ref)
        possible_locations.append(recurse_line(e, move_modifier[i], board_ref, location))
      elsif can_capture?(e, board_ref, location)
        possible_locations.append(e)
      end
    end
    collection = []
    possible_locations.uniq!
    temp = possible_locations.flat_map do |element|
      if element.is_a?(Array) && element.length == 2 && element.all? { |i| i.is_a?(Integer) }
        [element]
      else
        element
      end
    end

    temp.each do |each|
      collection << Notation.new().row_col_to_alg(each)
    end
    collection
  end


  def king_move(location, piece, board_ref)
    # * star
    # location = row,col
    king_piece = board_ref.get_row_column(location)
    move_modifier = [[1,0],[1,1],[0,1],[-1,1],[-1,0],[-1,-1],[-1,0],[0,-1],[1,-1]]
    threatend_spaces = {}
    queue = []
    queue = move_modifier.map { |mod| [location[0]+mod[0], location[1]+mod[1]] }
    collection = []
    possible_locations = []
    queue.each do |e|
      next if is_out_of_bounds?(e, board_ref)
      if location_empty?(e, board_ref) || can_capture?(e, board_ref, location)
        possible_locations.append(e)
      end
    end

    possible_locations.each do |each|
      temp = Notation.new().row_col_to_alg(each)
      collection << temp unless temp.nil?     
    end
    
    king_piece.color == 'white' ? threat_color = 'black' : threat_color = 'white'
    threats = []
    collection.each do |each|
      # this is the "easy" way to get a proper copy of the board hash
      alt_board_ref = Marshal.load(Marshal.dump(board_ref))
      target_location = Notation.new.alg_to_row_col(each)
      chess_piece = alt_board_ref.get_row_column(location)
      alt_board_ref.set_row_column(target_location, chess_piece)
      alt_board_ref.get_row_column(target_location).current_position = each
      alt_board_ref.set_row_column(location, nil)
      alt_board_ref.setup_squares
      threats = generate_threats(threat_color, board_ref, alt_board_ref)
      threats.delete_if { |k, v| v.empty? }
      threatend_spaces.merge!(threats)
    end
    collection.delete_if do |each|
      val = threatend_spaces.values.flatten
      val.include?(each)
    end
    collection.uniq!

    castle_moves = get_castle_moves(location, board_ref)
    collection.append(castle_moves) unless castle_moves == false || castle_moves.empty?
    collection
  end

  def rook_move(location, piece, board_ref)
    # - | or castle
    possible_locations = []
    move_modifier = [[1,0],[0,1],[-1,0],[0,-1]]
    queue = move_modifier.map { |e| [e[0] + location[0], e[1] + location[1]] }
    queue.each_with_index do |e, i|
      next if is_out_of_bounds?(e, board_ref)
      if location_empty?(e, board_ref)
        #possible_locations << e
        possible_locations << recurse_line(e, move_modifier[i], board_ref, location)
      elsif can_capture?(e, board_ref, location)
        possible_locations << e
      end
    end
    collection = []
    possible_locations.flatten(1).each do |each|
      if each.length > 2
        each.each do |e|
          temp = Notation.new().row_col_to_alg(e)
          collection << temp unless temp.nil?
        end
      else  
        temp = Notation.new().row_col_to_alg(each)
        collection << temp unless temp.nil?
      end      
    end
    

    collection
  end

  def get_castle_moves(location, board_ref)
    king = board_ref.get_row_column(location)
    return nil if king.name != 'king'
    moves = []
    white_kingside_rook_start_position = 'h1'
    white_queenside_rook_start_position = 'a1'
    black_kingside_rook_start_position = 'h8'
    black_queenside_rook_start_position = 'a8'
    if king.color == 'white'
      # check white rooks
      # check queenside

      if can_castle?(king, white_kingside_rook_start_position, board_ref)
        moves.append({king_target: king.current_position, rook_target: white_kingside_rook_start_position})
      end
      # check kingside
      if can_castle?(king, white_queenside_rook_start_position, board_ref)
        moves.append({king_target: king.current_position, rook_target: white_queenside_rook_start_position})
      end
    elsif king.color == 'black'
      # check black rooks
      # check queenside
      if can_castle?(king, black_kingside_rook_start_position, board_ref)
      # do something
        moves.append({king_target: king.current_position, rook_target: black_kingside_rook_start_position})
      end
      # check kingside
      if can_castle?(king, black_queenside_rook_start_position, board_ref)
      # do something
        moves.append({king_target: king.current_position, rook_target: black_queenside_rook_start_position})
      end
    else
      return []
    end
    moves
  end

  def castle_rule_1(king, rook_start, board_ref)
    white_king_start_position = 'e1'
    black_king_start_position = 'e8'
    if king.color == 'white'
      if king.current_position == white_king_start_position
        rook_square = board_ref.get_row_column(Notation.new().alg_to_row_col(rook_start))
        if rook_square.name == 'rook' && rook_square.color == 'white'
          return true
        end
      end
    elsif king.color == 'black'
      if king.current_position == black_king_start_position
        if rook_start.is_a?(String)
          rook_square = board_ref.get_row_column(Notation.new().alg_to_row_col(rook_start))
        else
          rook_square = board_ref.get_row_column(rook_start)
        end
        if rook_square.name == 'rook' && rook_square.color == 'black'
          return true
        end
      end
    else
      return false
    end
  end

  def castle_rule_2(king, rook, board_ref)
    sub_rule_2 = []
    rule_2 = false
    white_kingside_rook_start_position = 'h1'
    white_queenside_rook_start_position = 'a1'
    black_kingside_rook_start_position = 'h8'
    black_queenside_rook_start_position = 'a8'
    # rule 2 - nothing inbetween
    # white kingside, white queenside
    # black kingside, black queenside
    if rook == white_queenside_rook_start_position || rook == black_queenside_rook_start_position
      move_modifier = [[0,-1],[0,-2]]
      move_modifier.each do |each|
        interim_location = Notation.new.alg_to_row_col(king.current_position)
        interim_location = [interim_location[0] + each[0], interim_location[1] + each[1] ]
        piece_at_location = board_ref.get_row_column(interim_location)
        if piece_at_location.name != "space"
          return false
        else
          sub_rule_2 << true
        end 
      end
    elsif rook == white_kingside_rook_start_position || rook == black_kingside_rook_start_position
      move_modifier = [[0,1],[0,2]]
      move_modifier.each do |each|
        interim_location = Notation.new.alg_to_row_col(king.current_position)
        interim_location = [interim_location[0] + each[0], interim_location[1] + each[1]]
        piece_at_location = board_ref.get_row_column(interim_location)
        if piece_at_location.name != "space"
          return false
        else
          sub_rule_2 << true
        end 
      end
    else
      return false
    end
    rule_2 = true if sub_rule_2.all?(true)
  end

  def castle_rule_3(king, rook, board_ref)
    white_kingside_rook_start_position = 'h1'
    white_queenside_rook_start_position = 'a1'
    black_kingside_rook_start_position = 'h8'
    black_queenside_rook_start_position = 'a8'
    if king.color == 'black'
      threat_color = 'white'
    elsif king.color == 'white'
      threat_color == 'black'
    else
      return nil
    end
    threatend_spaces = generate_threats(threat_color, board_ref)
    if board_ref.get_row_column(Notation.new().alg_to_row_col(rook)) == white_kingside_rook_start_position || board_ref.get_row_column(Notation.new().alg_to_row_col(rook)) == black_kingside_rook_start_position
      move_modifier  = [0,3]
    else
      move_modifier = [0,-3]
    end
    start_location = Notation.new().alg_to_row_col(king.current_position)
    squares_to_check = move_modifier[0]+start_location[0], move_modifier[1]+start_location[1]

    # returns true if there is a threatend square, so invert that for logic below
    rule_3 = !threatend_spaces.include?(squares_to_check)
    return rule_3
  end

  def can_castle?(king, rook, board_ref)
    # check each rule for the king and rook in question
    # determine side of board
    # first rule
    rule_1 = castle_rule_1(king, rook, board_ref)
    return false if rule_1 == false
    
    # rule 2 - nothing inbetween
    # white kingside, white queenside
    # black kingside, black queenside

    rule_2 = castle_rule_2(king, rook, board_ref)
    return false if rule_2 == false 

    rule_3 = castle_rule_3(king, rook, board_ref)
    return false if rule_3 == false

    if [rule_1, rule_2, rule_3].all?(true)
      return true
    else
      return false
    end
  end

  # returns a hash of all threats
  # k is the location of the piece making the threat
  # v is the squares that the threating piece can move to
  def generate_threats(threat_color, board_ref, alt_board_ref = nil)
    alt_board_ref.nil? ? board = board_ref : board = alt_board_ref
    threats = {}
    board.board.each do |row|
      row.each do |item|
        next if item.nil?
        next unless item.is_a?(Piece)
        if item.color == threat_color
          location = item&.current_position
          location = Notation.new().alg_to_row_col(location)
          next if location.nil?
          case item.name
          when 'pawn'
            threats[item.current_position] = pawn_move(location, item, board)
          when 'bishop'
            threats[item.current_position] = bishop_move(location, item, board)
          when 'queen'
            threats[item.current_position] = queen_move(location, item, board)
          when 'king'
            # causes infinite recursion
            #threats[item.current_position] = king_move(location, item, board)
          when 'rook'
            threats[item.current_position] = rook_move(location, item, board)
          when 'knight'
            threats[item.current_position] = knight_move(location, item, board)
          end
        end
      end
    end
    threats
  end

  def get_en_passant(location, board_ref)
    # return nil
    moves = []
    main_pawn_location = location
    # check left spot to see if en passant is possible
    # repeat for right
    captured_pawn_location = location[0], location[1] - 1
    main_piece = board_ref.get_row_column(main_pawn_location)
    potential_capture_piece = board_ref.get_row_column(captured_pawn_location)
    if (potential_capture_piece.name == 'pawn' || potential_capture_piece.color != main_piece.color) && !is_out_of_bounds?(captured_pawn_location, board_ref)
      passant_rule_1 = check_passant_rule_1(main_pawn_location, board_ref)
      passant_rule_2 = check_passant_rule_2(main_pawn_location, captured_pawn_location, board_ref)
      passant_rule_3 = check_passant_rule_3(captured_pawn_location, board_ref)

      if [passant_rule_1, passant_rule_2, passant_rule_3].all?(true)

        main_pawn_location_alg = Notation.new.row_col_to_alg(main_pawn_location)
        captured_pawn_location_alg = Notation.new.row_col_to_alg(captured_pawn_location)
        if main_piece.color == 'white'
          end_position = [captured_pawn_location[0] - 1, captured_pawn_location[1]]
        else
          end_position = [captured_pawn_location[0] + 1, captured_pawn_location[1]]
        end
        end_position_alg = Notation.new.row_col_to_alg(end_position)

        moves.append({capturing_pawn: main_pawn_location_alg, pawn_to_be_captured: captured_pawn_location_alg, end_position: end_position_alg})
      end
    end

    captured_pawn_location = location[0], location[1] + 1
    potential_capture_piece = board_ref.get_row_column(captured_pawn_location)
    return nil if potential_capture_piece.nil?

    if (potential_capture_piece.name == 'pawn' || potential_capture_piece.color != main_piece.color) && !is_out_of_bounds?(captured_pawn_location, board_ref)
      passant_rule_1 = check_passant_rule_1(main_pawn_location, board_ref)
      passant_rule_2 = check_passant_rule_2(main_pawn_location, captured_pawn_location, board_ref)
      passant_rule_3 = check_passant_rule_3(captured_pawn_location, board_ref)

      if [passant_rule_1, passant_rule_2, passant_rule_3].all?(true)

        main_pawn_location_alg = Notation.new.row_col_to_alg(main_pawn_location)
        captured_pawn_location_alg = Notation.new.row_col_to_alg(captured_pawn_location)

        if main_piece.color == 'white'
          end_position = [captured_pawn_location[0] - 1, captured_pawn_location[1]]
        else
          end_position = [captured_pawn_location[0] + 1, captured_pawn_location[1]]
        end
        end_position_alg = Notation.new.row_col_to_alg(end_position)

        moves.append({capturing_pawn: main_pawn_location_alg, pawn_to_be_captured: captured_pawn_location_alg, end_position: end_position_alg})
      end
    end

    return nil if moves.empty?
    moves
  end

  def check_passant_rule_1(main_pawn_location, board_ref)
    # rules from chess.com
    # the capturing pawn must have advanced exactly three ranks
    # compare original position to current, then compare to see if it equals 3 ranks
    main_pawn = board_ref.get_row_column(main_pawn_location)
    # check if same col, i.e. e4->e7 check if 'e' is the same
    return false if main_pawn.current_position.nil? || main_pawn&.original_position.nil?
    if main_pawn.current_position[0] == main_pawn.original_position[0] 
      if (main_pawn.current_position[1].to_i - main_pawn.original_position[1].to_i).abs == 3
        return true
      end
    end
    false
  end

  def check_passant_rule_2(main_pawn_location, captured_pawn_location, board_ref)
    # the captured pawn must have moved two squares in one move, landing next to the capturing pawn
    # is the captured_pawn next to the main pawn
    if main_pawn_location[1]+1 == captured_pawn_location[1] || main_pawn_location[1]-1 == captured_pawn_location[1]
      # if captured pawn moved two squares last turn
      # last[1] => new_location_alg
      # check if same end location
      last_move = board_ref.move_history.last
      return nil if last_move.nil?
      if last_move[1] == Notation.new.row_col_to_alg(captured_pawn_location)
        # check if row changed by 2 spaces
        if ((Notation.new.alg_to_row_col(last_move[0]))[0] - (Notation.new.alg_to_row_col(last_move[1]))[0]).abs == 2
          return true
        end
      end
    end
    false
  end
  
  def check_passant_rule_3(captured_pawn_location, board_ref)
    # the capture must be done immediately after the captured pawn moves, otherwise it is invalid
    # this should really be called when making the move, but since i'm checking before giving the option this rule is weird
    last_move = board_ref.move_history.last
    return false if last_move.nil?
    if last_move[1] == Notation.new.row_col_to_alg(captured_pawn_location)
      return true
    end
    false
  end

  def get_moves(location, piece, board)
    moves = []
    case piece.name
    when 'pawn'
      moves = pawn_move(location, piece, board)
    when 'bishop'
      moves = bishop_move(location, piece, board)
    when 'queen'
      moves = queen_move(location, piece, board)
    when 'king'
      moves = king_move(location, piece, board)
    when 'rook'
      moves = rook_move(location, piece, board)
    when 'knight'
      moves = knight_move(location, piece, board)
    end
    moves
  end
end