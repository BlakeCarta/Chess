# placeholder file, will manage game state
# will facilitate input and board interacting
# will handle user/ai interactions with input manager
class GameManager
  def initialize
    @input_manager = nil
    @board_manager = nil
    @player = nil
    @ai_player = nil
  end

  attr_reader :input_manager, :board_manager, :player, :ai_player
end
