require 'piece_moves.rb'
class Piece
  include PieceMoves
  def initialize(arguments = {})
    @name = arguments[:name]
    @color = arguments[:color]
    @current_position = arguments[:current_position]
    @icon = arguments[:icon]
    @original_position ||= arguments[:original_position]
  end
  attr_accessor :name, :color, :current_position, :icon, :original_position
end