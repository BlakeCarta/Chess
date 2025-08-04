require './lib/custom_data'.freeze
# Reads Portable Game Notation files (.txt) and converts them into Custom Data format
class PgnReader
  def initialize(name = nil)
    @full_text = nil
    @collected_turns = []
    @headers = { Event: nil, Site: nil, Date: nil, Round: nil, White: nil, Black: nil, Result: nil }
    @filename = name.nil? ? 'example_input' : name
  end

  attr_reader :filename

  def read_example_file
    file = File.open("./PGN/import/#{@filename}.pgn")
    @full_text = file.readlines.map do |line|
      line = line.chomp.split('')
      next if line.first.nil?

      line.join('')
    end
    file.close
    @full_text
  end

  def breakup_lines(line)
    line.split(' ')
  end

  def extract_turn_data(line)
    collected_comment = []
    collected_turns = []
    current_turn = 0
    white_move, black_move = nil

    line.each do |item|
      # if this is a special character, like the end of match notation ensure currently stored data is writtent to array
      if special_characters?(item)
        collected_turns[current_turn] = CustomData.new(current_turn, white_move, black_move, collected_comment)
        next
      end
      # get and set turn number if that is in the current item
      current_turn = set_turn_number(item, current_turn)

      # get and set white move if that is current item
      white_move = set_white_move(item, white_move)

      # get and set black move if that is the current item
      black_move = set_black_move(item, black_move, collected_comment)

      # get and set the comment if that is the current item
      collected_comment = set_comment(item, collected_comment)

      # if both moves not set, don't write to array yet
      next if white_move.nil? || black_move.nil?

      # if both moves set, add them into the array and reset moves
      collected_turns[current_turn] = CustomData.new(current_turn, white_move, black_move, collected_comment)
      white_move, black_move = nil
    end
    @collected_turns = collected_turns
  end

  # Handle multi line input in a single string
  def cleanup_lines(lines)
    lines.join(' ').split
  end

  def get_all(lines = nil)
    # if given lines, extract them to @collected_turns, otherwise just get the already created list
    extract_turn_data(cleanup_lines(lines)) unless lines.nil?
    @collected_turns
  end

  def get_headers(lines = nil)
    lines = @full_text if lines.nil?

    lines.each do |line|
      next if line.nil? || line[0] != '['

      line = line.delete('[]\"')
      # Split line into chunks
      line = line.chomp.split(' ')

      line_key = line[0].to_sym
      line_data = line[1..].join(' ')

      set_header(line_key, line_data)
    end
    @headers
  end

  def set_header(key, data)
    @headers[key] = data
  end

  def special_characters?(text)
    # End of match is a tie
    if text.match('1/2-1/2')
      @headers[:result] = text
      return true
    end
    false
  end

  # if turn start (digit with dot)
  def set_turn_number(text, current_turn)
    # double digits
    if text.match(/\d+\d+\./)
      current_turn = text[0..1].to_i
    # single digits
    elsif text.match(/\d+\./)
      current_turn = text[0].to_i
    end

    current_turn
  end

  def set_white_move(text, white_move)
    # white move = '.'
    if text.count('.') == 1 && text.count('}').zero?
      white_move = text[2..].match(/\./) ? text[3..] : text[2..]
    end
    white_move
  end

  def set_black_move(text, black_move, collected_comment)
    # black move = '...'
    if text.count('.') == 3 || text.count('.') > 1
      black_move = text[4..]
    # if white move added and black isnt, but guard against reading white to black and against writing comments
    elsif !text.match(/\d+\./) && !text.match('{') && collected_comment.empty?
      black_move = text
    end
    black_move
  end

  def set_comment(text, collected_comment)
    # if comment ( { or } )
    if text.match('{') && collected_comment.empty?
      collected_comment << text[1..]
    elsif text.match('}')
      collected_comment << text[0...-1]
      collected_comment = collected_comment.join(' ')
    elsif !collected_comment.empty? && collected_comment.is_a?(Array)
      collected_comment << text
    end

    collected_comment
  end
end
