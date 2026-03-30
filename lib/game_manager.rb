# will facilitate input and board interacting
# will handle user/ai interactions with input manager
require_relative './input_manger'
require_relative './board/board_manager'
require_relative './player'
require_relative './ai_player'
require_relative './human_player'
require_relative 'check'
require_relative 'save_or_load'
class GameManager
  include CHECK
  include STORAGE
  def initialize
    @input_manager = Input_Manager
    @board_manager = Board_Manager.new
    @player = HumanPlayer.new
    @ai_player = AiPlayer.new(@board_manager)
    @player_in_check = false
    @ai_player_in_check = false
    @checkmate = false
  end

  attr_accessor :input_manager, :board_manager, :player, :ai_player
  attr_reader :player_in_check, :ai_player_in_check, :checkmate

  def play_game
  end

  def play_round
    print_board
    player_turn
    check_board_for_upgrades(@player.color)
    update_check(@board_manager)
    return nil if @checkmate == true

    print_board
    ai_turn
    check_board_for_upgrades(@ai_player.color)
    update_check(@board_manager)
    return nil if @checkmate == true

    puts 'End of Round!'
    print_board
    true
  end

  def start_message
    'Welcome to chess, game will start shortly!'
  end

  def default_start
    set_default_colors
    set_board
  end

  def show_board
    @board_manager.get_board
  end

  def get_capture_history
    @board_manager.capture_history
  end

  def get_full_move_history
    @board_manager.full_move_history
  end

  def valid_player_move?(player_input)
    return false if player_input.nil? || player_input == 'save' || player_input == 'load'

    return_cordinates = true
    move_list = @board_manager.get_location(player_input[1]).get_moves(@board_manager, return_cordinates)
    player_input[0] == 'move' && move_list.include?(player_input[2])
  end

  def player_turn
    player_input_valid = false
    player_input = ''
    while player_input_valid == false && !player_input.nil?
      puts player_turn_message
      # should only get nil if somehow the player doesnt make a move
      # otherwise it will get a split move ([move, e4, e5])/ or a split select ([select, e4])
      # Should return [0,0] instead of 'a1'

      player_input = @input_manager.play_turn

      return 'quit' if player_used_quit?(player_input)

      player_input_valid = determine_player_action(player_input)
    end
    print_end_of_player_turn_text
  end

  def ai_turn
    loop do
      puts ai_player_turn_message
      ai_action = @ai_player.make_move(@board_manager)
      ai_action.unshift('move')
      # break if valid move otherwise, try again
      break if determine_player_action(ai_action)
    end
  end

  private

  def set_default_colors
    @player.color = 'white'
    @ai_player.color = 'black'
  end

  def set_board
    @board_manager.setup_board
  end

  def ai_player_turn_message
    'The computer will now make a move!'
  end

  def player_turn_message
    'Player Turn!'
  end

  def print_end_of_player_turn_text
    puts 'End of Player turn'
  end

  def determine_player_action(player_input)
    if valid_player_move?(player_input)
      player_used_move(player_input)
      return true
    elsif is_special_move?(player_input)
      handle_special_move(player_input)
      return true
    else
      command = if player_input.is_a?(Array)
                  player_input[0]
                else
                  player_input
                end

      case command
      when 'select'
        # posistion to select
        player_used_select(player_input)
        return true
      when 'save'
        player_used_save(player_input)
        return true
      when 'load'
        # loading files should be multiple inputs
        player_used_load(player_input)
        return true
      end
    end
    false
  end

  def check_board_for_upgrades(color)
    temp = []
    if color == 'black'
      temp = @board_manager.get_board[0].map do |location|
        !location.is_a?(String) && location.name == 'pawn' && location.color == color
      end
      return get_upgrade(color, [0, temp.find_index(true)]) if temp.any?(true)
    else
      temp = @board_manager.get_board[7].map do |location|
        !location.is_a?(String) && location.name == 'pawn' && location.color == color
      end
      return get_upgrade(color, [7, temp.find_index(true)]) if temp.any?(true)
    end
    nil
  end

  def get_upgrade(color, location)
    upgrade_type = if color == @ai_player.color
                     @ai_player.get_upgrade
                   else
                     @input_manager.get_upgrade
                   end
    handle_special_move({ upgrade_type: upgrade_type, original_posistion: location, color: color })
  end

  def is_special_move?(input)
    return false if input.is_a?(String)

    player_input = input.find { |e| e.is_a?(Hash) }
    return false unless player_input.is_a?(Hash)

    if player_input.key?(:new_king_posistion) && player_input.key?(:new_rook_posistion)
      return true
    elsif player_input.key?(:can_capture) && player_input.key?(:new_capturing_posistion)
      return true
    elsif player_input.key?(:new_piece_type)
      return true
    end

    false
  end

  def handle_special_move(input)
    if input.is_a?(Array)
      player_input = input.find { |e| e.is_a?(Hash) }
    elsif input.is_a?(Hash)
      player_input = input
    else
      return false
    end
    return false if player_input.nil?

    # castle
    #           castle_move_right = { king_original_posistion: [0, 4], rook_original_posistion: [0, 7],
    # new_king_posistion: [0, 6], new_rook_posistion: [0, 5] }
    # en passant
    #             en_passant = { original_capturing_posistion: new_posistion, original_captured_posistion: [4, 3],
    # new_capturing_posistion: [5, 3], can_capture: true }
    # upgrade
    if player_input.key?(:new_king_posistion) && player_input.key?(:new_rook_posistion)
      # then its a castle move
      # call move twice
      @board_manager.move_piece(player_input[:king_original_posistion], player_input[:new_king_posistion])
      @board_manager.move_piece(player_input[:rook_original_posistion], player_input[:new_rook_posistion])
    elsif player_input.key?(:can_capture) && player_input.key?(:new_capturing_posistion)
      # then its an en passant
      # call move for pawn to desired location
      @board_manager.move_piece(player_input[:original_capturing_posistion], player_input[:new_capturing_posistion])
      captured_piece = @board_manager.get_location(player_input[:original_captured_posistion])
      @board_manager.delete_location(player_input[:original_captured_posistion])
      @board_manager.add_to_capture_history(captured_piece)
    elsif player_input.key?(:upgrade_type)
      # upgrade
      @board_manager.delete_location(player_input[:original_posistion])
      piece = Piece.new(type: player_input[:upgrade_type], posistion: player_input[:original_posistion],
                        color: player_input[:color])
      @board_manager.set_location(player_input[:original_posistion], piece)
    end
  end

  def check_for_pawn_upgrades(color)
    index_target = if color == 'white'
                     7
                   else
                     0
                   end

    @board_manager.get_board.each_with_index do |row, index|
      next if index != index_target

      row.each_with_index do |square, col_index|
        next if square == 'x'
        next if square.color != color

        return get_upgrade_info([index, col_index], color) if square.name == 'pawn'
      end
    end
  end

  def get_upgrade_info(location, color)
    choice = if color == @player.color
               @input_manager.get_upgrade
             else
               @ai_player.get_upgrade
             end
    { upgrade_type: choice, original_posistion: location,
      color: color }
  end

  def player_used_select(player_input)
    puts @board_manager.get_location(player_input[1]).get_moves(@board_manager) if player_input[0] == 'select'
  end

  def player_used_move(player_input)
    @board_manager.move_piece(player_input[1], player_input[2])
  end

  def player_used_save(player_input)
    player_input == 'save'
    # save logic called here
    data = {
      input_manager: @input_manager,
      board: @board_manager.get_board,
      board_capture_history: @board_manager.capture_history,
      board_full_move_history: @board_manager.full_move_history,
      player: @player,
      ai_player: @ai_player,
      player_in_check: @player_in_check,
      ai_player_in_check: @ai_player_in_check,
      checkmate: @checkmate
    }
    STORAGE.save(nil, data)
  end

  def player_used_load(player_input)
    player_input[0] == 'load'
    # load logic here
    instance_vars = STORAGE.load

    set_instance_vars(instance_vars)
  end

  def set_instance_vars(instance_vars)
    @board_manager = instance_vars[:board_manager]
    @player = instance_vars[:player]
    @ai_player = instance_vars[:ai_player]
    @player_in_check = instance_vars[:player_in_check]
    @ai_player_in_check = instance_vars[:ai_player_in_check]
    @checkmate = instance_vars[:checkmate]
  end

  def player_used_quit?(player_input)
    player_input == 'quit'
  end

  def print_board
    @board_manager.draw_board
  end

  def update_check(board_manager)
    @ai_player_in_check = CHECK.in_check?(board_manager, ai_player.color)
    @player_in_check = CHECK.in_check?(board_manager, player.color)

    return unless [@ai_player_in_check, @player_in_check].any?(true)

    check_for_checkmate
    return unless @checkmate == true

    nil
  end

  def check_for_checkmate
    color = if @ai_player_in_check
              @ai_player.color
            else
              @player.color
            end

    @checkmate = if can_get_out_of_check?(@board_manager, color)
                   false
                 else
                   true
                 end
  end

  def can_get_out_of_check?(board_manager, color)
    !CHECK.get_out_of_check(board_manager, color).nil?
  end
end
