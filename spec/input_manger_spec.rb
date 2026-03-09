# frozen_string_literal: true

require_relative '../lib/input_manger'
describe Input_Manager do
  subject { Input_Manager }

  # describe '#generic_turn' do
  #  it 'players turn is handled correctly' do
  #    player_turn = 'player'
  #
  #    output_text = "Please input your action\nPlease input your desired target piece\n"
  #    allow($stdin).to receive(:gets).and_return('select', 'e4', 'move', 'e4', 'e5')
  #    expect do
  #      subject.generic_turn
  #    end.to output(output_text).to_stdout
  #  end
  #
  #  it 'handles a select, move, quit, select, move, quit, move command chain' do
  #    output_text = "Please input your action\nPlease input your desired target piece\nPlease input your action\nPlease input your desired target piece\nPlease input your desired target piece\nreplace with real moves\n"
  #    allow($stdin).to receive(:gets).and_return('select', 'move', 'quit', 'select', 'move', 'quit', 'move')
  #    expect do
  #      subject.generic_turn
  #    end.to output(output_text).to_stdout
  #  end
  # end

  describe '#valid_input?' do
    it 'returns true for move e5 e6' do
      expect(subject.valid_input?('move e5 e6')).to be true
    end

    it 'returns false for move z8 e6' do
      expect(subject.valid_input?('move z8 e6')).to be false
    end

    it 'returns false for no input' do
      expect(subject.valid_input?('')).to be false
    end

    it 'returns false for gibberish' do
      expect(subject.valid_input?('qwoepriu')).to be false
    end

    it 'handles nil input' do
      expect(subject.valid_input?(nil)).to be false
    end
  end

  describe '#move_command' do
    xit 'gets moves from the board' do
      # WIP
    end
  end

  describe '#select_commmand' do
    xit 'gets the available moves from the board' do
      # WIP
    end
  end

  describe '#save_command' do
    xit 'sends the save command to the game' do
    end
  end

  describe '#load_command' do
    xit 'sends the load command to the game' do
    end
  end

  describe '#quit_command' do
    xit 'sends the quit command to the game' do
    end
  end

  describe '#convert_row_col_to_posistion' do
    it 'returns e4 for 3,4' do
      input = [3, 4]
      expected = 'e4'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns a1 for 0,0' do
      input = [0, 0]
      expected = 'a1'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns h8 for 7,7' do
      input = [7, 7]
      expected = 'h8'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns h5 for 4,7' do
      input = [4, 7]
      expected = 'h5'

      expect(subject.convert_row_col_to_posistion(input)).to eq(expected)
    end

    it 'returns nil for invalid input' do
      input = ['el']

      expect(subject.convert_row_col_to_posistion(input)).to be_nil
    end

    it 'returns nil for no input' do
      input = []

      expect(subject.convert_row_col_to_posistion(input)).to be_nil
    end

    it 'returns nil for gibberish' do
      input = [1, 'thebluefox']

      expect(subject.convert_row_col_to_posistion(input)).to be_nil
    end
  end

  describe '#convert_posistion_to_row_col' do
    it 'returns 3,4 for e4' do
      input = 'e4'
      expected = [3, 4]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns 0,0 for a1' do
      input = 'a1'
      expected = [0, 0]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns 7,7 for h8' do
      input = 'h8'
      expected = [7, 7]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns 4,7 for h5' do
      input = 'h5'
      expected = [4, 7]

      expect(subject.convert_posistion_to_row_col(input)).to eq(expected)
    end

    it 'returns nil for invalid input' do
      input = 'el'

      expect(subject.convert_posistion_to_row_col(input)).to be_nil
    end

    it 'returns nil for no input' do
      input = ''

      expect(subject.convert_posistion_to_row_col(input)).to be_nil
    end

    it 'returns nil for gibberish' do
      input = 'thebluefox'

      expect(subject.convert_posistion_to_row_col(input)).to be_nil
    end
  end
end
