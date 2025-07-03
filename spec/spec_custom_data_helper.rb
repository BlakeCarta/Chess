require 'rspec/expectations'

RSpec::Matchers.define :equivalent_turn_of do |expected|
  match do |actual|
    expected.turn_number == actual.turn_number
  end
end

RSpec::Matchers.define :equivalent_white_move_of do |expected|
  match do |actual|
    expected.white_move == actual.white_move
  end
end

RSpec::Matchers.define :equivalent_black_move_of do |expected|
  match do |actual|
    expected.black_move == actual.black_move
  end
end

RSpec::Matchers.define :equivalent_comment_of do |expected|
  match do |actual|
    expected.comment == actual.comment
  end
end

RSpec::Matchers.define :equivalent_all_items_of do |expected|
  match do |actual|
    expected.all_items == actual.all_items
  end
end

RSpec::Matchers.define :full_equivalent_of do |expected|
  match do |actual|
    temp_list = []
    expected.each_with_index do |each, index|
      temp_list << equivalent_turn_of(actual[index])
      temp_list << equivalent_white_move_of(actual[index])
      temp_list << equivalent_black_move_of(actual[index])
      temp_list << equivalent_comment_of(actual[index])
      temp_list << equivalent_all_items_of(actual[index])
    end
    temp_list.all?
  end
end