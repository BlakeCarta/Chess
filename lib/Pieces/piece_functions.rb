# require_relative 'piece.rb'
require_relative 'piece_castle'
require_relative 'piece_en_passant'

module Piece_functions
  include CastleFunctions
  include EnPassantFunctions

  def set_new_posistion(new_posistion)
    @root.update_posistion(new_posistion)
  end

  def get_posistion
    @root.posistion
  end

  def name
    @root.name
  end

  def color
    @root.color
  end

  def icon
    @root.icon
  end

  def move_history
    @root.move_history
  end

  # def get_move_options_row_col
  #  @root.children.map { |piece| piece.get_posistion }
  # end

  def get_moves(board_manager, return_cordinates = false)
    # @root.children
    @board_manager = board_manager

    # should i write different bfs/dfs versions for each piece
    moves = if simple_moves?
              simple_move
            else
              depth_moves
            end

    moves += castle_moves if can_castle?
    moves += en_passant if can_en_passant?

    # reset board manager, not optimal to store a ref to board when not needed
    @board_manager = nil

    # return pieces, unless requested as cordinates
    # techinically this is suboptimal, but it should'nt have a big impact
    # but a rewrite would could make this better
    return moves unless return_cordinates == true

    # moves.map { |pieces| pieces.get_posistion }

    moves.map do |pieces|
      if pieces.is_a?(Hash)
        # if name == 'king'
        #  pieces[:new_king_posistion]
        # else
        #  pieces[:new_rook_posistion]
        # end
        pieces
      else
        pieces.get_posistion
      end
    end
  end

  private

  def simple_moves?
    simple_pieces = %w[pawn king knight]
    simple_pieces.include?(name)
  end

  def capture?(location)
    return false if @board_manager.get_location(location).is_a?(String)

    @board_manager.get_location(location).color != color
  end

  def empty_square?(location)
    @board_manager.get_location(location).is_a?(String) || @board_manager.get_location(location).name.nil?
  end

  def in_bounds?(location)
    location.map { |e| e.between?(0, 7) }.all? { |bool| bool == true }
  end

  def valid?(location)
    in_bounds?(location) && (capture?(location) || empty_square?(location))
  end

  def pawn_moved?
    name == 'pawn' && !move_history.empty?
  end

  # depth based move, not pure dfs, might benefit from rewrite
  # returns cordinates for now
  def depth_moves
    child_nodes = @root.move_list.map { |each| [each[0] + get_posistion[0], each[1] + get_posistion[1]] }

    i = 0
    offset = @root.move_list[i]
    possible_nodes = []
    current_node = child_nodes.shift

    until i >= @root.move_list.length || current_node.nil?
      if valid?(current_node)
        possible_nodes << current_node
        # if capture set to dummy value after add, else add then offset
        current_node = if capture?(current_node)
                         # dummy value to ensure next iteration increments, need a cleaner solution
                         [-1, -1]
                       else
                         [offset[0] + current_node[0], offset[1] + current_node[1]]
                       end

      else
        i += 1
        current_node = child_nodes.shift
        offset = @root.move_list[i]
      end
    end
    # convert all possible posistions into Pieces? - b/c thats what the other methods do
    possible_nodes.map { |node| Piece.new(type: name, posistion: node, color: color) }
    # possible_nodes
  end

  def simple_move
    # pawns cant move 2 spaces if it has already moved
    @moves.shift if pawn_moved?

    @root.children.keep_if { |piece| capture?(piece.get_posistion) || empty_square?(piece.get_posistion) }
  end

  def make_pawn(type, posistion, color)
    @moves = if color == 'white'
               [[2, 0], [1, 0]]
             else
               [[-2, 0], [-1, 0]]
             end
    Generic_Piece.new(type, 'P', color, posistion)
  end

  def make_knight(type, posistion, color)
    @moves = [[2, 1], [1, 2], [-1, 2], [-2, 1], [-2, -1], [-1, -2], [1, -2], [2, -1]]
    Generic_Piece.new(type, 'N', color, posistion)
  end

  def make_queen(type, posistion, color)
    @moves = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    Generic_Piece.new(type, 'Q', color, posistion)
  end

  def make_rook(type, posistion, color)
    @moves = [[1, 0], [0, 1], [-1, 0], [0, -1]]
    Generic_Piece.new(type, 'R', color, posistion)
  end

  def make_bishop(type, posistion, color)
    @moves = [[1, 1], [-1, 1], [-1, -1], [1, -1]]
    Generic_Piece.new(type, 'B', color, posistion)
  end

  def make_king(type, posistion, color)
    @moves = [[1, 0], [1, 1], [0, 1], [-1, 1], [-1, 0], [-1, -1], [0, -1], [1, -1]]
    Generic_Piece.new(type, 'K', color, posistion)
  end

  def promote
    # do thing
  end
end
