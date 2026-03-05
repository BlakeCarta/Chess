# frozen_string_literal: true

# code related to checking and getting castle moves for a piece
module CastleFunctions
  # rook checks on the king
  def castle_moves_from_rooks
    # return false unless @board_manager.get_location([get_posistion[0], 4]).move_history.empty?

    castle_move = []
    # if king hasnt moved
    if @board_manager.get_location([get_posistion[0], 4]).move_history.empty?
      if castle_can_move_right
        castle_move += [get_posistion[0], 5]
      elsif castle_can_move_left
        castle_move += [get_posistion[0], 2]
      end
    end

    castle_move
  end

  # king checks on the rooks
  def castle_moves_from_king
    castle_move = []
    if @board_manager.get_location([get_posistion[0], 0]).move_history.empty? && castle_can_move_left

      castle_move += [get_posistion[0], 2]
    end
    # check right rook
    if @board_manager.get_location([get_posistion[0], 7]).move_history.empty? && castle_can_move_right

      castle_move += [get_posistion[0], 5]
    end
    # return false if castle_move.empty?

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
