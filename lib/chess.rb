require_relative 'board/board_manager.rb'
require_relative 'input_manger.rb'
class Chess
  def initialize
    @Board_Manager = Board_Manager.new
    #@Input_Manager = Input_Manager.new
  end

  def play_turn(input, player_color)
    # row, col
    target_location, current_location = Input_Manager.get_input

    return nil unless vaild_input?(current_location, target_location)
    
    #captured_piece = @board.move(target_rc, current_rc, player_color)
    captured_piece = @Board_Manager.move_piece(current_location, target_location)

    puts "#{player_color} captured a #{captured_piece.name}" unless captured_piece.nil?
  end

  private

  def vaild_input?(current_location, target_location)
    possible_moves = get_all_moves(current_location)

    possible_moves.include?(target_location)
  end

  def get_all_moves(current_location)
    piece = @Board_Manager.get_location(current_location)
    piece.get_moves(@Board_Manager)
  end
end