require 'yaml'
module STORAGE
  def self.save(filename = nil, data)
    filename = get_save_filename if filename.nil?
    write_to_yaml(filename, data)
  end

  def self.load(filename = nil)
    filename = get_load_filename if filename.nil?
    read_from_yaml(filename)
  end

  def self.write_to_yaml(filename, data)
    File.open("./saves/#{filename}.yml", 'w') do |file|
      YAML.dump(data, file)
    end
  end

  def self.read_from_yaml(filename)
    classes = [Piece, Symbol, Generic_Piece, HumanPlayer, RSpec::Mocks::InstanceVerifyingDouble,
               RSpec::Mocks::NamedObjectReference, AiPlayer]

    YAML.load_file("./saves/#{filename}.yml", permitted_classes: classes,
                                              aliases: true)
  end

  def self.get_save_filename
    puts 'Please input a name for your save file: '
    @input_manager.get_filename
  end

  def self.get_load_filename
    puts 'Here is the current available save files: '
    print_saved_games
    puts 'Please input the name of the file you wish to load: '
    @input_manager.get_filename
  end

  def self.print_saved_games
    saved_games = Dir.entries('saves')
    if saved_games.empty?
      puts 'No saves found'
      return nil
    end

    saved_games.map do |file|
      puts "FILE: #{file}"
    end
  end

  def self.compare_board_data(ref_board, loaded_board)
    board_location_checks = []
    ref_board.each_with_index do |row, rindex|
      row.each_with_index do |col, cindex|
        board_location_checks << ((loaded_board[rindex][cindex].is_a?(String) == col.is_a?(String)) || (loaded_board[rindex][cindex].name == col.name) && (loaded_board[rindex][cindex].color == col.color))
      end
    end
    board_location_checks
  end
end
