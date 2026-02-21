require_relative "./board.rb"
class Board_Manager
  def initialize
    @board = Game_Board.new
    @capture_history = []
  end

  attr_reader :capture_history

  def get_board
    @board.gameboard
  end

  def set_location(location, value)
    @board.set_location(location, value)
  end

  def delete_location(location)
    @board.set_location(location, nil)
  end

  def get_location(location)
    @board.get_location(location)
  end

  def add_to_capture_history(piece)
    @capture_history.append(piece)
    piece
  end

  def move_piece(location, target_location)
    captured_piece = nil
    unless get_location(target_location).nil?
      captured_piece = add_to_capture_history(get_location(target_location))
    end

    set_location(target_location, get_location(location))
    set_location(location, nil)

    fix_board

    captured_piece
  end

  def draw_board
    @board.gameboard.map { |row| puts "#{row}" }
  end

  private

  def setup_board
    # need logic
    @board
  end

  def fix_board
    # repair nils to squares
    8.times do |row|
      8.times do |col|
        square = get_location([row-1,col-1])
        if square.nil?
          set_location([row-1,col-1], "x")
        end
      end
    end
  end

end