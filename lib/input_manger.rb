module Input_Manager
  # def self.get_input(input_text)
  #  # target = [3, 0]
  #  # current = [1, 1]
  #  # [target, current]
  #  return update_action(input_text) if is_user_actions?(input_text)
  #
  #  convert_posistion_to_row_col(input_text)
  # end

  def play_turn
    @current_command = nil
    command = nil

    while @current_command != 'quit' || command == 'quit'

      puts 'Please input your desired action: '
      puts 'example move e5 e6, or select e5 to see moves, or quit/save/load'

      command = $stdin.gets.chomp
      until valid_input?(command)
        puts 'please try another input'
        command = $stdin.gets.chomp
        break if command == 'quit'
      end
      act_on_command(command) unless command == 'quit'
    end
    puts 'Turn over!'
  end

  def act_on_command(command)
    command_arr = command.split(' ')

    case command_arr.first
    when 'move'
      # posistion to move, destination
      move_command(command_arr[1], command_arr[2])
    when 'select'
      # posistion to select
      select_command(command_arr[1])
    when 'save'
      save_command
    when 'load'
      load_command
    when 'quit'
      quit_command
    end
  end

  def self.valid_input?(input)
    split_text = input.split(' ')
    game_commands = %w[save quit load]
    if split_text[0] == 'move' && !convert_posistion_to_row_col(split_text[1]).nil? && !convert_posistion_to_row_col(split_text[2]).nil?
      true
    elsif split_text[0] == 'select' && !convert_posistion_to_row_col(split_text[1]).nil?
      true
    elsif game_commands.include?(split_text[0])
      true
    else
      false
    end
  end

  def self.reset_mode
    @current_mode = nil
  end

  def self.get_current_mode
    @current_mode
  end

  def self.convert_posistion_to_row_col(input_text)
    columns = { 'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }
    column = columns[input_text[0]&.downcase&.to_sym]
    row = input_text[1]&.to_i&.- 1

    return nil if column.nil? || row.nil? || !row.between?(0, 7)

    [row, column]
  end

  def self.convert_row_col_to_posistion(input_text)
    columns = { 0 => 'a', 1 => 'b', 2 => 'c', 3 => 'd', 4 => 'e', 5 => 'f', 6 => 'g', 7 => 'h' }
    column = columns[input_text[1]]
    row = input_text[0]&.to_i&.+ 1

    return nil if column.nil? || row.nil? || !row.between?(1, 8)

    [column, row].join('')
  end

  private

  def self.update_action(input_text)
    # placeholder, meant to update state, i.e. move mode, select mode
    @current_mode = user_action(input_text)
  end

  def self.move_command(posistion_to_move, destination)
    # send move to board for validation
  end

  def self.select_command(posistion)
    # send posistion to board, and print out moves
  end

  def self.save_command
    # save not implemented yet
  end

  def self.load_command
    # not implemented yet
  end

  def self.quit_command
    @current_mode = 'quit'
  end
end
