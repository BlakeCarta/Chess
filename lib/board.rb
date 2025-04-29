class ChessBoard
  def initialize
    @board = Array.new(8) {Array.new(8)}
  end
  attr_reader :board
end