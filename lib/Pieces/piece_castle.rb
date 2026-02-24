# code related to checking and getting castle moves for a piece
module CastleFunctions
  def get_castle_moves_from_rooks
    # return false unless @board_manager.get_location([get_posistion[0], 4]).move_history.empty?

    castle_move = []
    # if king hasnt moved
    if @board_manager.get_location([get_posistion[0], 4]).move_history.empty?
      if move_history.empty? && castle_can_move_right
        castle_move += [get_posistion[0], 5]
      elsif move_history.empty? && castle_can_move_left
        castle_move += [get_posistion[0], 2]
      end
    end

    castle_move
  end

  def get_castle_moves_from_king
    castle_move = []
    if @board_manager.get_location([get_posistion[0],
                                    0]).move_history.empty? && castle_can_move_left && move_history.empty?

      castle_move += [get_posistion[0], 2]
    end
    # check right rook
    if @board_manager.get_location([get_posistion[0],
                                    7]).move_history.empty? && castle_can_move_right && move_history.empty?

      castle_move += [get_posistion[0], 5]
    end
    # return false if castle_move.empty?

    castle_move
  end

  def can_castle?
    return false unless castle_moves.empty?

    # can this accidentally default to true?
    true
  end

  def castle_moves
    # check if rook/king
    return false unless %w[rook king].include?(name)
    # check if either have moved
    return false unless move_history.empty?

    castle_move = []
    if name == 'rook'
      castle_move = get_castle_moves_from_rooks
    elsif name == 'king'
      castle_move = get_castle_moves_from_king
    end

    castle_move
  end

  def castle_can_move_left
    @board_manager.get_location(get_posistion[0], 3).is_a?(String) &&
      @board_manager.get_location(get_posistion[0], 2).is_a?(String) # &&
    # @board_manager.get_location(get_posistion[0], 1).move_history.empty?
  end

  def castle_can_move_right
    @board_manager.get_location(get_posistion[0], 5).is_a?(String) &&
      @board_manager.get_location(get_posistion[0], 6).is_a?(String) # &&
    # @board_manager.get_location(get_posistion[0], 7).move_history.empty?
  end

  def add_castle_move(king_posistion, rook_posistion)
    { king_original_posistion: king_posistion, rook_original_posistion: rook_posistion, new_king_posistion: 'shrug',
      new_rook_posistion: 'idkman' }
  end
end
