require './lib/custom_data.rb'
#require './spec/spec_custom_data_helper.rb'

describe CustomData do
  context '#have_equal_turns' do
    subject(:data_one) { described_class.new(38) }
    subject(:data_two) { described_class.new(38) }
    it 'has the same turn number' do
      expect(data_one).to have_equal_turns(data_two)
    end
  end

  context '#have_equal_turns' do
    subject(:data_one) { described_class.new(25) }
    subject(:data_two) { described_class.new(15) }
    it 'does not have the same turn numbers' do
      expect(data_one).not_to have_equal_turns(data_two)
    end
  end

  context '#have_equal_white_moves' do
    subject(:data_one) { described_class.new(38, 'g3') }
    subject(:data_two) { described_class.new(38, 'g3') }
    it 'has the same move for the white player' do
      expect(data_one).to have_equal_white_moves(data_two)
    end
  end

  context '#have_equal_white_moves' do
    subject(:data_one) { described_class.new(38, 'g3') }
    subject(:data_two) { described_class.new(38, 'g4') }
    it 'does not have the same move for the white player' do
      expect(data_one).not_to have_equal_white_moves(data_two)
    end
  end

  context '#have_equal_black_moves' do
    subject(:data_one) { described_class.new(38, 'g3', 'Nxh3') }
    subject(:data_two) { described_class.new(38, 'g3', 'Nxh3') }
    it 'has the same move for the black player' do
      expect(data_one).to have_equal_black_moves(data_two)
    end
  end

  context '#have_equal_black_moves' do
    subject(:data_one) { described_class.new(38, 'g3', 'Nxh3') }
    subject(:data_two) { described_class.new(38, 'g3', 'Bxh3') }
    it 'does not have the same move for the black player' do
      expect(data_one).not_to have_equal_black_moves(data_two)
    end
  end

  context '#have_equal_comments' do
    subject(:data_one) { described_class.new(3, 'Bb5', 'a6', 'This opening is called the Ruy Lopez.') }
    subject(:data_two) { described_class.new(3, 'Bb5', 'a6', 'This opening is called the Ruy Lopez.') }
    it 'has the same comment' do
      expect(data_one).to have_equal_comments(data_two)
    end
  end

  context '#have_equal_comments' do
    subject(:data_one) { described_class.new(3, 'Bb5', 'a6', 'This opening is called the Ruy Lopez.') }
    subject(:data_two) { described_class.new(3, 'Bb5', 'a6', 'This opening is called a blunder.') }
    it 'does not have the comment' do
      expect(data_one).not_to have_equal_comments(data_two)
    end
  end

  context '#have_all_items_equal' do
    subject(:data_one) { described_class.new(1, 'e4', 'e5') }
    subject(:data_two) { described_class.new(1, 'e4', 'e5') }
    it 'is true' do
      expect(data_one).to have_all_items_equal(data_two)
    end
  end
  
  context '#have_all_items_equal' do
    subject(:data_one) { described_class.new(1, 'e3', 'e5') } 
    subject(:data_two) { described_class.new(1, 'e5', 'e5') }
    it 'does not have all the same items' do
      expect(data_one).not_to have_all_items_equal(data_two)
    end


    subject(:example_extracted_turn_data) { described_class.new }
    it 'correctly detects incorrect input' do
      example_input = ["1.e4", "b88", "2.Nf3", "Nc6", "3.Bb5", "{This", "opening", "is", "called", "the", "Ruy", "Lopez.}", "3...a6"]
      turn_1 = described_class.new(1, "e4", "e5")
      turn_2 = described_class.new(2, "Nf3", "Nc6")
      turn_3 = described_class.new(3, "Bb5", "a6", "This opening is called the Ruy Lopez.")

      turn_1_correct = described_class.new(1, "e82", "e5")

      actual_turn_data = [nil, turn_1, turn_2, turn_3]
      expected_turn_data = [nil, turn_1_correct, turn_2, turn_3]
      expect(actual_turn_data).not_to have_array_of_all_items_equal(expected_turn_data)
    end


    subject(:example_extracted_turn_data) { described_class.new }
    it 'correctly reads the correct input' do
      example_input = ["11.c4", "c6", "12.cxb5", "axb5", "13.Nc3", "Bb7", "14.Bg5", "b4", "15.Nb1", "h6", "16.Bh4", "c5", "17.dxe5"]
      turn_11 = described_class.new(11, "c4", "c6")
      turn_12 = described_class.new(12, "cxb5", "axb5")
      turn_13 = described_class.new(13, "Nc3", "Bb7")
      turn_14 = described_class.new(14, "Bg5", "b4")
      turn_15 = described_class.new(15, "Nb1", "h6")
      turn_16 = described_class.new(16, "Bh4", "c5")
      turn_17 = described_class.new(17, "dxe5")

      actual_turn_data = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, turn_11, turn_12, turn_13, turn_14, turn_15, turn_16, turn_17]
      expected_turn_data = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, turn_11, turn_12, turn_13, turn_14, turn_15, turn_16, turn_17]
      expect(actual_turn_data).to have_array_of_all_items_equal(expected_turn_data)
    end

    subject(:example_extracted_turn_data) { described_class.new }
    it 'correctly identifies a mismatch' do
      example_input = ["11.c4", "c6", "12.cxb5", "axb5", "13.Nc3", "Bb7", "14.Bg5", "b4", "15.Nb1", "h6", "16.Bh4", "c5", "17.dxe5"]
      turn_11 = described_class.new(11, "c4", "c6")
      turn_12 = described_class.new(12, "cxb5", "axb5")
      turn_13 = described_class.new(13, "Nc3", "Bb7")
      turn_14 = described_class.new(14, "Bg5", "b4")
      turn_15 = described_class.new(15, "Nb1", "h6")
      turn_16 = described_class.new(16, "Bh4", "c5")
      turn_17 = described_class.new(17, "dxe5")

      wrong_turn_17 = described_class.new(17, "dxe5", "c6")

      actual_turn_data = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, turn_11, turn_12, turn_13, turn_14, turn_15, turn_16, wrong_turn_17]
      expected_turn_data = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, turn_11, turn_12, turn_13, turn_14, turn_15, turn_16, turn_17]
      expect(actual_turn_data).not_to have_array_of_all_items_equal(expected_turn_data)
    end
  end
end
