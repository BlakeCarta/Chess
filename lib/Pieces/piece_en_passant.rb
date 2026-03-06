module EnPassantFunctions
  # rules
  # Be a pawn
  # Capturing pawn must be on 5th rank
  # Captured pawn must be on the 4th rank
  # Captured pawn must have moved 2 spaces
  # Captured pawn must have landed next to your pawn
  # Must use capture that turn

  def can_en_passant?
    get_target_posistions.each do |target_posistion|
      check_en_passant?(target_posistion)
    end
  end

  def check_en_passant?(target_posistion)
    is_pawn? && on_capturing_rank? && captured_pawn_moved_2_spaces?(target_posistion) && captured_pawn_next_to_capturing_pawn?(target_posistion) && !couldve_used_capture_last_turn?
  end

  def en_passant
    moves = []
    get_target_posistions.map do |target_posistion|
      moves << make_en_passant(target_posistion) if check_en_passant?(target_posistion)
    end
    moves
  end

  private

  def make_en_passant(pawn_target_posistion)
    new_posistion = if color == 'white'
                      [pawn_target_posistion[0] + 1, pawn_target_posistion[1]]
                    else
                      [pawn_target_posistion[0] - 1, pawn_target_posistion[1]]
                    end

    { original_capturing_posistion: get_posistion, original_captured_posistion: pawn_target_posistion,
      new_capturing_posistion: new_posistion }
  end

  def get_target_posistions
    target_posistions = [get_posistion[0], get_posistion[1] + 1], [get_posistion[0], get_posistion[1] - 1].delete_if do |pos|
      pos.each do |cord|
        cord > 7 || cord < 0
      end
    end

    target_posistions.select { |posistion| posistion.name == 'pawn' }
  end

  def is_pawn?
    name == 'pawn'
  end

  def on_capturing_rank?
    # white = 5th rank
    # black = 4th rank
    if color == 'white' && get_posistion[0] == 4
      true
    elsif color == 'black' && get_posistion[0] == 3
      true
    else
      false
    end
  end

  def captured_pawn_moved_2_spaces?(target_posistion)
    captured_pawn = @board_manager.get_location(target_posistion)
    return false if captured_pawn.name != 'pawn'

    if captured_pawn.move_history.size == 1
      if captured_pawn.color == 'black'
        return true if target_posistion[0] == 4
      elsif captured_pawn.color == 'white'
        return true if target_posistion[0] == 3
      end
    end
    false
  end

  def captured_pawn_next_to_capturing_pawn?(target_posistion)
    (target_posistion[0] == get_posistion[0]) && ((target_posistion[1] - get_posistion[1]).abs == 1)
  end

  def couldve_used_capture_last_turn?
    @board_manager.full_move_history[-2] == move_history.last
  end
end
