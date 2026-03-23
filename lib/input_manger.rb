module Input_Manager
  def self.play_turn
    puts 'Please input your desired action: '
    puts 'example move e5 e6, or select e5 to see moves, or quit/save/load'

    command = $stdin.gets.chomp
    until valid_input?(command)
      return nil if command == 'quit'

      puts 'please try another input'
      command = $stdin.gets.chomp
    end

    split_input = convert_input(command.split(' '))
    return split_input unless split_input.nil? || split_input[0] == 'quit'

    nil

    # return nil unless command == 'move'
  end

  def self.convert_input(split_text)
    if split_text[0] == 'move' && !convert_posistion_to_row_col(split_text[1]).nil? && !convert_posistion_to_row_col(split_text[2]).nil?
      [split_text[0], convert_posistion_to_row_col(split_text[1]), convert_posistion_to_row_col(split_text[2])]
    elsif split_text[0] == 'select' && !convert_posistion_to_row_col(split_text[1]).nil?
      [split_text[0], convert_posistion_to_row_col(split_text[1])]
    else
      split_text
    end
  end

  def self.valid_input?(input)
    split_text = input&.split(' ')
    return false if split_text.nil?

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

  def get_filename
    # this function is extremely simple for now
    # but should allow for more complex logic if required
    $stdin.gets.chomp
  end
end
