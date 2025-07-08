require './lib/custom_data'
# Reads Portable Game Notation files (.txt) and converts them into Custom Data format
class PgnReader
  def initialize(name = nil)
    @full_text = nil
    @collected_turns = []
    @headers = { Event: nil, Site: nil, Date: nil, Round: nil, White: nil, Black: nil, Result: nil }
    @filename = if name.nil?
                  'example_input'
                else
                  name
                end
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
    is_commment = false
    collected_comment = []
    # export variable
    collected_turns = [] 
    current_turn_num = 0
    current_turn = nil
    white_move = nil
    black_move = nil


    line.each do |item|
      # if Turn start (digit with dot)
      if item.match(/\d+\./) && is_commment == false
        if !current_turn.nil?
          collected_turns[current_turn_num] = current_turn
        end
        if item.match(/\d+\d+\./)
          current_turn_num = item[0..1].to_i
        else
          current_turn_num = item[0].to_i
        end
        if item.count('.') == 1
          if item[2..-1].match(/\./)
            white_move = item[3..-1]
          else
            white_move = item[2..-1]
          end
        elsif item.count('.') == 3 || item.count('.') < 1 
          if item.length > 3
            black_move = item[4..-1]
          else
            black_move = item
          end
        end
      end

      if !white_move.nil? && item.match(/\d+\./)
        black_move = item
      end

      # if comment ( { or } )
      if item.match('{') && is_commment == false
        is_commment = true
        #collected_comment = []
        collected_comment << item[1..-1]
      elsif item.match('}')
        collected_comment << item[0...-1]
        collected_comment = collected_comment.join(' ')
        is_commment = false
      elsif is_commment == true
        collected_comment << item
      end
      if !white_move.nil? && !black_move.nil? 
        if collected_comment == []
          collected_comment = nil
        end
        collected_turns[current_turn_num] = CustomData.new(current_turn_num, white_move, black_move, collected_comment)
        collected_comment = []
        white_move = nil
        black_move = nil
      end
    end
    @collected_turns = collected_turns
  end

  def get_all(lines = nil)
    if lines.nil?
      @collected_turns
    else
      extract_turn_data(lines)
      @collected_turns.each { |each| each.nil? ? next : each.all_items }
      @collected_turns
    end
  end


  def get_headers(lines = nil) # this, then move spec helpers? then parse moves?
    if lines.nil?
      lines = @full_text
    end
    lines.each do |line|
      if line.nil?
        next
      end

      if line[0] == '['
        line = line.delete('[')
        line = line.delete(']')
        line = line.delete('\\"') # found on stack overflow, said may have unintended consequences
        #split line into chunks
        line = line.chomp.split(' ')

        line_key = line[0].to_sym
        line_data = line[1..-1].join(' ')

        set_header(line_key, line_data)
      end
    end
    @headers
  end

  def set_header(key, data)
    @headers[key] = data
  end

end