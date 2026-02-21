class Game_Board
  def initialize
    @gameboard = Array.new(8) { Array.new(8, "x") }
  end

  attr_reader :gameboard

  def get_location(location)
    @gameboard[location[0]][location[1]]
  end

  def set_location(location, value)
    @gameboard[location[0]][location[1]] = value
  end
end