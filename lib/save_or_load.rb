require 'yaml'
module STORAGE
  def self.save(filename = nil)
    filename = get_save_filename if filename.nil?
    write_to_yaml(filename)
  end

  def self.load
    filename = get_load_filename
    read_from_yaml(filename)
  end

  def self.write_to_yaml(filename)
    data = {
      input_manager: @input_manager,
      board_manager: @board_manager,
      player: @player,
      ai_player: @ai_player,
      player_in_check: @player_in_check,
      ai_player_in_check: @ai_player_in_check,
      checkmate: @checkmate
    }

    File.open("./saves/#{filename}.yml", 'w') do |file|
      file.write(data.to_yaml)
    end
  end

  def self.read_from_yaml(filename)
    instance_vars = YAML.load_file("./saves/#{filename}.yml")

    @input_manager = instance_vars[:input_manager]
    @board_manager = instance_vars[:board_manager]
    @player = instance_vars[:player]
    @ai_player = instance_vars[:ai_player]
    @player_in_check = instance_vars[:player_in_check]
    @ai_player_in_check = instance_vars[:ai_player_in_check]
    @checkmate = instance_vars[:checkmate]
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
end
