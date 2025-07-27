module CustomDataHelper
  require 'rspec/expectations'

  RSpec::Matchers.define :have_equal_turns do |expected|
    match do |actual|
      actual.turn_number == expected.turn_number
    end

    failure_message do |actual|
      "Expected Turn number #{expected.turn_number} to be equal to #{actual.turn_number}"
    end

    failure_message_when_negated do |actual|
      "Expected Turn number #{expected.turn_number} to not be equal to #{actual.turn_number}"
    end

    description do
      'Compares turn numbers.'
    end
  end

  RSpec::Matchers.define :have_equal_white_moves do |expected|
    match do |actual|
      expected.white_move == actual.white_move
    end

    failure_message do |actual|
      "Expected white move #{expected.white_move} to be equal to #{actual.white_move}"
    end

    failure_message_when_negated do |actual|
      "Expected white move #{expected.white_move} to not be equal to #{actual.white_move}"
    end

    description do
      "Compares white player's move."
    end
  end

  RSpec::Matchers.define :have_equal_black_moves do |expected|
    match do |actual|
      expected.black_move == actual.black_move
    end

    failure_message do |actual|
      "Expected black move #{expected.black_move} to be equal to #{actual.black_move}"
    end

    failure_message_when_negated do |actual|
      "Expected black move #{expected.black_move} to not be equal to #{actual.black_move}"
    end

    description do
      "Compares black player's move."
    end
  end

  RSpec::Matchers.define :have_equal_comments do |expected|
    match do |actual|
      expected.comment == actual.comment
    end

    failure_message do |actual|
      "Expected the comment #{expected.comment} to be equal to #{actual.comment}"
    end

    failure_message_when_negated do |actual|
      "Expected the comment #{expected.comment} to not be equal to #{actual.comment}"
    end

    description do
      'Compares commentary associated with the turn.'
    end
  end

  RSpec::Matchers.define :have_all_items_equal do |expected|
    match do |actual|
      expected.all_items == actual.all_items
    end

    failure_message do |actual|
      failure_message = "Expected Turn number #{expected.turn_number} to be equal to #{actual.turn_number}"
      failure_message += "Expected white move #{expected.white_move} to be equal to #{actual.white_move}"
      failure_message += "Expected black move #{expected.black_move} to be equal to #{actual.black_move}"
      failure_message + "Expected the comment #{expected.comment} to be equal to #{actual.comment}"
    end

    failure_message_when_negated do |actual|
      failure_message = "Expected Turn number #{expected.turn_number} to not be equal to #{actual.turn_number}"
      failure_message += "Expected white move #{expected.white_move} to not be equal to #{actual.white_move}"
      failure_message += "Expected black move #{expected.black_move} to not be equal to #{actual.black_move}"
      failure_message + "Expected the comment #{expected.comment} to not be equal to #{actual.comment}"
    end

    description do
      'Checks @all_items of CustomData object, which contains a copy of all data for easy comparison.'
    end
  end

  RSpec::Matchers.define :have_array_of_all_items_equal do |expected|
    match do |actual|
      temp_list = []
      actual.each_with_index do |each, index|
        expected_index = expected[index]
        temp_list = if each.nil? && expected_index.nil?
                      temp_list << true
                    elsif !each.nil? && expected_index.nil? || each.nil? && !expected_index.nil?
                      temp_list << false
                    else
                      temp_list << (each.all_items == expected_index.all_items)
                    end
      end
      temp_list.all?
    end



    failure_message do |actual|
      failure_message = ""
      actual.each_with_index do |actual_turn_data, index|
        expected_index = expected[index]
        if (actual_turn_data.nil? != expected_index.nil?) || (actual_turn_data&.all_items != expected_index&.all_items)
          failure_message = "Expected Turn number #{expected_index.turn_number} to be equal to #{actual_turn_data.turn_number}\n"
          failure_message += "Expected white move #{expected_index.white_move} to be equal to #{actual_turn_data.white_move}\n"
          failure_message += "Expected black move #{expected_index.black_move} to be equal to #{actual_turn_data.black_move}\n"
          failure_message += "Expected the comment #{expected_index.comment} to be equal to #{actual_turn_data.comment}\n"
          break
        end
      end
      failure_message
    end

    failure_message_when_negated do |actual|
      failure_message = ""
      actual.each_with_index do |actual_turn_data, index|
        expected_index = expected[index]
        if (actual_turn_data.nil? != expected_index.nil?) || (actual_turn_data&.all_items == expected_index&.all_items)
          failure_message = "Expected Turn number #{expected_index.turn_number} to not be equal to #{actual_turn_data.turn_number}\n"
          failure_message += "Expected white move #{expected_index.white_move} to not be equal to #{actual_turn_data.white_move}\n"
          failure_message += "Expected black move #{expected_index.black_move} to not be equal to #{actual_turn_data.black_move}\n"
          failure_message += "Expected the comment #{expected_index.comment} to not be equal to #{actual_turn_data.comment}\n"
          break
        end
      end
      failure_message
    end

    description do
      'Compares arrays, using the @all_items property to ensure each CustomData object of each array matches the corresponding object.'
    end
  end
end
