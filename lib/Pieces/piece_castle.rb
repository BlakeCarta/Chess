# frozen_string_literal: true

# Checks and gets castle moves for king or rook
module CastleFunctions
  # rook checks on the king
  def castle_moves_from_rooks
    castle_move = []
    # if king hasnt moved
    if @board_manager.get_location([get_posistion[0], 4]).move_history.empty?
      if castle_can_move_right
        castle_move += create_right_castle_move
      elsif castle_can_move_left
        castle_move += create_left_castle_move
      end
    end

    castle_move
  end

  # king checks on the rooks
  def castle_moves_from_king
    castle_move = []
    if @board_manager.get_location([get_posistion[0], 0]).move_history.empty? && castle_can_move_left

      castle_move += create_left_castle_move
    end
    # check right rook
    if @board_manager.get_location([get_posistion[0], 7]).move_history.empty? && castle_can_move_right

      castle_move += create_right_castle_move
    end

    castle_move
  end

  def can_castle?
    return true unless castle_moves.empty?

    false
  end

  def castle_moves
    castle_move = []

    # check if rook/king
    return castle_move unless %w[rook king].include?(name)
    # check if either have moved
    return castle_move unless move_history.empty?

    if name == 'rook'
      castle_move = castle_moves_from_rooks
    elsif name == 'king'
      castle_move = castle_moves_from_king
    end

    castle_move
  end

  private

  def castle_can_move_left
    @board_manager.get_location(get_posistion[0], 3).is_a?(String) &&
      @board_manager.get_location(get_posistion[0], 2).is_a?(String) &&
      @board_manager.get_location(get_posistion[0], 1).is_a?(String)
  end

  def castle_can_move_right
    @board_manager.get_location(get_posistion[0], 5).is_a?(String) &&
      @board_manager.get_location(get_posistion[0], 6).is_a?(String)
  end

  def add_castle_move(original_king_posistion, original_rook_posistion, new_king_posistion, new_rook_posistion)
    { king_original_posistion: original_king_posistion, rook_original_posistion: original_rook_posistion,
      new_king_posistion: new_king_posistion, new_rook_posistion: new_rook_posistion }
  end

  def create_right_castle_move
    # king moves to 6, rook moves to 5
    original_king_posistion = [get_posistion[0], 4]
    original_rook_posistion = [get_posistion[0], 7]
    new_king_posistion = [get_posistion[0], 6]
    new_rook_posistion = [get_posistion[0], 5]

    add_castle_move(original_king_posistion, original_rook_posistion, new_king_posistion,
                    new_rook_posistion)
  end

  def create_left_castle_move
    # king moves to 2, rook moves to 3
    original_king_posistion = [get_posistion[0], 4]
    original_rook_posistion = [get_posistion[0], 0]
    new_king_posistion = [get_posistion[0], 2]
    new_rook_posistion = [get_posistion[0], 3]

    add_castle_move(original_king_posistion, original_rook_posistion, new_king_posistion,
                    new_rook_posistion)
  end
end
