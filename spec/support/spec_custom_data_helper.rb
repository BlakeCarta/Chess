require 'rspec/expectations'

RSpec::Matchers.define :equivalent_turn_of do |expected|
  match do |actual|
    actual.turn_number == expected.turn_number
  end

  failure_message do |actual|
    "Expected Turn number #{expected.turn_number} to be equal to #{actual.turn_number}"
  end

  failure_message_when_negated do |actual|
    "Expected Turn number #{expected.turn_number} to not be equal to #{actual.turn_number}"
  end
end

RSpec::Matchers.define :equivalent_white_move_of do |expected|
  match do |actual|
    expected.white_move == actual.white_move
  end

  failure_message do |actual|
    "Expected white move #{expected.white_move} to be equal to #{actual.white_move}"
  end

  failure_message_when_negated do |actual|
    "Expected white move #{expected.white_move} to not be equal to #{actual.white_move}"
  end
end

RSpec::Matchers.define :equivalent_black_move_of do |expected|
  match do |actual|
    expected.black_move == actual.black_move
  end

  failure_message do |actual|
    "Expected black move #{expected.black_move} to be equal to #{actual.black_move}"
  end

  failure_message_when_negated do |actual|
    "Expected black move #{expected.black_move} to not be equal to #{actual.black_move}"
  end
end

RSpec::Matchers.define :equivalent_comment_of do |expected|
  match do |actual|
    expected.comment == actual.comment
  end

  failure_message do |actual|
    "Expected the comment #{expected.comment} to be equal to #{actual.comment}"
  end

  failure_message_when_negated do |actual|
    "Expected the comment #{expected.comment} to not be equal to #{actual.comment}"
  end
end

RSpec::Matchers.define :equivalent_all_items_of do |expected|
  match do |actual|
    expected.all_items == actual.all_items
  end

  failure_message do |actual|
    "Expected Turn number #{expected.turn_number} to be equal to #{actual.turn_number},
    Expected white move #{expected.white_move} to be equal to #{actual.white_move},
    Expected black move #{expected.black_move} to be equal to #{actual.black_move},
    Expected the comment #{expected.comment} to be equal to #{actual.comment}"
  end

  failure_message_when_negated do |actual|
    "Expected Turn number #{expected.turn_number} to not be equal to #{actual.turn_number},
    Expected white move #{expected.white_move} to not be equal to #{actual.white_move},
    Expected black move #{expected.black_move} to not be equal to #{actual.black_move},
    Expected the comment #{expected.comment} to not be equal to #{actual.comment}"
  end

  description do
    "Checks @all_items of CustomData object which contains a copy of all data for easy comparison"
  end
end

RSpec::Matchers.define :array_equivalent_all_items_of do |expected|
  match do |actual|
    temp_list = []
    actual.each_with_index do |each, index|
      if each.nil? && expected[index].nil?
        temp_list << true
      elsif !each.nil? && expected[index].nil? || each.nil? && !expected[index].nil?
        temp_list << false
      else
        temp_list << each.all_items == expected[index].all_items
      end
    end
    temp_list.all?
  end

  failure_message do |actual|
    actual.each_with_index do |each, index|
      if each.all_items != actual[index].all_items
        "Expected Turn number #{each.turn_number} to be equal to #{actual[index].turn_number},
        Expected white move #{each.white_move} to be equal to #{actual[index].white_move},
        Expected black move #{each.black_move} to be equal to #{actual[index].black_move},
        Expected the comment #{each.comment} to be equal to #{actual[index].comment}"
        break
      end
    end
  end


  failure_message_when_negated do |actual|
    actual.each_with_index do |each, index|
      if each.all_items == actual[index].all_items
        "Expected Turn number #{each.turn_number} to not be equal to #{actual[index].turn_number},
        Expected white move #{each.white_move} to not be equal to #{actual[index].white_move},
        Expected black move #{each.black_move} to not be equal to #{actual[index].black_move},
        Expected the comment #{each.comment} to not be equal to #{actual[index].comment}"
        break
      end
    end
  end

  description do
    "Similar to equivalent_all_items_of, but ensures each CustomData object of an arry matches expected"
  end
end
