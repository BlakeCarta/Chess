# placeholder file, will manage game state
# will facilitate input and board interacting
# will handle user/ai interactions with input manager
require_relative './input_manger'
require_relative './board/board_manager'
require_relative './player'
require_relative './ai_player'
require_relative './human_player'
class GameManager
  def initialize
    @input_manager = Input_Manager
    @board_manager = Board_Manager.new
    @player = HumanPlayer.new
    @ai_player = AiPlayer.new
  end

  attr_accessor :input_manager, :board_manager, :player, :ai_player

  def start_message
    'Welcome to chess, game will start shortly!'
  end

  def set_default_colors
    @player.color = 'white'
    @ai_player.color = 'black'
  end

  def set_board
    @board_manager.setup_board
  end

  def show_board
    @board_manager.get_board
  end

  def valid_player_move?(player_input)
    return false if player_input.nil? || player_input == 'save' || player_input == 'load'

    move_list = @board_manager.get_location(player_input[1]).get_moves(@board_manager)
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
      # break if valid move otherwise, try again
      break if determine_player_action(ai_action)
    end
  end

  private

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

  def player_used_select(player_input)
    puts @board_manager.get_location(player_input[1]).get_moves(@board_manager) if player_input[0] == 'select'
  end

  def player_used_move(player_input)
    @board_manager.move_piece(player_input[1], player_input[2])
  end

  def player_used_save(player_input)
    player_input == 'save'
    # save logic called here
  end

  def player_used_load(player_input)
    player_input[0] == 'load'
    # load logic here
  end

  def player_used_quit?(player_input)
    player_input == 'quit'
  end
end
