# require_relative 'node.rb'
class Generic_Piece
  def initialize(name = "", icon = "", color = "", posistion = [])
    @name = name
    @icon = icon
    @color = color
    # @piece_node = Node.new(posistion)
    # row, col
    @posistion = posistion

    @move_list = []
    @move_history = []
  end

  attr_reader :color, :posistion, :move_history, :move_list
  attr_accessor :name, :icon

  #def get_posistion
  #  # @piece_node.current_pos
  #  @posistion
  #end

  def update_posistion(new_posistion)
    add_to_move_history(@posistion)
    @posistion = new_posistion
  end

  def set_move_list(moves)
    @move_list = moves
  end
  
  def add_to_move_history(move)
    @move_history.append(move)
  end

  #def get_move_history
  #  @move_history
  #end

  def children
    child_nodes = []
    @move_list.map do |offset|
      new_posistion = [posistion[0] + offset[0], posistion[1] + offset[1]]
      if within_bounds?(new_posistion) #&& !visited?(new_posistion)
        # name = "", icon = "", color = "", posistion = []
        # child_nodes << Piece.new(new_posistion, self)
        #child_nodes << Piece.new(name, new_posistion, color)
        child_nodes << Piece.new(type: name, posistion: new_posistion, color: color)
      end
    end
    child_nodes
  end


  private

  # row, col
  def within_bounds?(posistion)
    posistion[0].between?(0,7) && posistion[1].between?(0,7)
  end


end