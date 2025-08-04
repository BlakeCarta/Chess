class CustomData
  def initialize(turn_number = nil, white_move = nil, black_move = nil, comment = nil)
    @turn_number = turn_number
    @white_move = white_move
    @black_move = black_move
    # if comment is '[]' set it to nil, otherwise set to passed value
    # prevents false test failures due to how current tests are conducted
    @comment = comment == [] ? nil : comment
    @all_items = []
  end
  attr_accessor :turn_number, :white_move, :black_move, :comment

  def all_items
    @all_items = [@turn_number, @white_move, @black_move, @comment]
  end
  
end