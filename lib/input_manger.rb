module Input_Manager
  def self.get_input(input_text)
    # target = [3, 0]
    # current = [1, 1]
    # [target, current]
    return update_action(input_text) if is_user_actions?(input_text)

    convert_posistion_to_row_col(input_text)
  end

  def self.generic_turn
    reset_mode
    user_input = nil
    while user_input.nil?
      puts 'Please input your action'

      user_input = get_input($stdin.gets.chomp)
      user_input = user_mode_actions(user_input) unless @current_mode.nil?
      break if @current_mode == 'move' && user_input.is_a?(Array)
    end
    user_input
  end

  def self.user_mode_actions(user_input)
    if @current_mode == 'select'
      until user_input.is_a?(Array) || user_input == 'quit'
        puts 'Please input your desired target piece'
        user_input = get_input($stdin.gets.chomp)
        get_moves_from_board(user_input)
      end
    elsif @current_mode == 'move'
      until user_input.is_a?(Array) || user_input == 'quit'
        puts 'Please input your desired target piece'
        user_input = get_input($stdin.gets.chomp)
        get_moves_from_board(user_input)
      end
    end

    user_input
  end

  def self.get_moves_from_board(posistion)
    # placeholder
    puts 'e5'
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

  def self.is_user_actions?(input_text)
    supported_actions = %w[select quit move save load]
    clean_text = user_action(input_text)

    return true if supported_actions.include?(clean_text)

    false
  end

  def self.user_action(input_text)
    input_text.chomp.downcase
  end

  private

  def self.update_action(input_text)
    # placeholder, meant to update state, i.e. move mode, select mode
    @current_mode = user_action(input_text)
  end
end
