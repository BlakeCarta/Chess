# File to call that will run a basic game
class Game
  require './lib/board.rb'
  require './lib/pgn_reader.rb'
  def initialize
  end

  def show_example_outputs
    @example = ChessBoard.new
    @example.setup_board
    @example.print_board
    setup_example_reader
    puts "Example reader output: "
    @example_reader.get_all(@example_file).each do |each|
      next if each.nil?
      message = "Turn number #{each.turn_number} "
      message += "White move #{each.white_move} "
      message += "Black move #{each.black_move} "
      message += "The comment #{each.comment}"
      puts message
    end
  end

  def setup_example_reader
    @example_reader = PgnReader.new
    @example_file = @example_reader.read_example_file
  end

end

new_game = Game.new
new_game.show_example_outputs