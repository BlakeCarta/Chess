require_relative './board'
require_relative '../Pieces/piece'
class Board_Manager
  def initialize
    @board = Game_Board.new
    @capture_history = []
    @full_move_history = []
  end

  attr_reader :capture_history
  attr_accessor :full_move_history

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
    captured_piece = add_to_capture_history(get_location(target_location)) unless get_location(target_location).nil?

    set_location(target_location, get_location(location))
    set_location(location, nil)

    fix_board

    captured_piece
  end

  def get_threatend_squares(friendly_color)
    threatend_squares = []
    @board.gameboard.map do |row|
      row.map do |square|
        next if square.is_a?(String)

        if square.color != friendly_color
          # pass board_manager and return cordinates
          threatend_squares << square.get_moves(self, true)
        end
      end
    end
    threatend_squares
  end

  def draw_board
    # ensure a newline
    puts ''
    output_text = @board.gameboard.map do |row|
      puts(row.map do |square|
        square.is_a?(String) ? square : square.icon
      end.join(' '))
    end

    output_text.delete_if(&:nil?)
  end

  def setup_board
    all_piece_locations = { black_pawns: { locations: [[6, 0], [6, 1], [6, 2], [6, 3], [6, 4], [6, 5], [6, 6], [6, 7]], color: 'black', type: 'pawn' },
                            white_pawns: { locations: [[1, 0], [1, 1], [1, 2], [1, 3], [1, 4], [1, 5], [1, 6], [1, 7]],
                                           color: 'white', type: 'pawn' },
                            white_rooks: { locations: [[0, 0], [0, 7]], color: 'white', type: 'rook' },
                            black_rooks: { locations: [[7, 7], [7, 0]], color: 'black', type: 'rook' },
                            white_knights: { locations: [[0, 1], [0, 6]], color: 'white', type: 'knight' },
                            black_knights: { locations: [[7, 1], [7, 6]], color: 'black', type: 'knight' },
                            white_bishops: { locations: [[0, 2], [0, 5]], color: 'white', type: 'bishop' },
                            black_bishops: { locations: [[7, 2], [7, 5]], color: 'black', type: 'bishop' },
                            white_queen: { locations: [[0, 3]], color: 'white', type: 'queen' },
                            black_queen: { locations: [[7, 3]], color: 'black', type: 'queen' },
                            white_king: { locations: [[0, 4]], color: 'white', type: 'king' },
                            black_king: { locations: [[7, 4]], color: 'black', type: 'king' } }
    all_piece_locations.each_value do |piece_info|
      piece_info[:locations].each do |location|
        set_location(location,
                     Piece.new(type: piece_info[:type], posistion: location, color: piece_info[:color]))
      end
    end
    fix_board
  end

  def find_piece(player_color, piece_name)
    return player_color if player_color.nil?
    return piece_name if piece_name.nil?

    get_board.each_with_index do |row, index|
      row.each_with_index do |square, col_index|
        next if square == 'x'
        next if square.color != player_color

        return [index, col_index] if square.name == piece_name
      end
    end
  end

  private

  def fix_board
    # repair nils to squares
    8.times do |row|
      8.times do |col|
        square = get_location([row - 1, col - 1])
        set_location([row - 1, col - 1], 'x') if square.nil?
      end
    end
  end
end
