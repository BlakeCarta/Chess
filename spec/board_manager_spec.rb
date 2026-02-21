require_relative '../lib/board/board_manager.rb'
describe Board_Manager do
  subject { Board_Manager.new }
  describe '#get_board' do
    it 'returns the correct default board' do
      expected = [["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"]]
                  
      expect(subject.get_board).to match_array(expected)
    end
    
  end

  describe '#set_location' do
    it 'sets location row 3, col 2' do
      expected = [["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "y", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"]]

      row = 3
      col = 2
      location = [row, col]
      value = "y"
      subject.set_location(location, value)

      expect(subject.get_board).to match_array(expected)
    end
  end

  describe '#delete_location' do
    it 'sets the target to nil' do
      expected = [["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", nil, "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"]]

      row = 5
      col = 5
      location = [row, col]
      
      subject.delete_location(location)

      expect(subject.get_board).to match_array(expected)
    end
  end

  describe '#get_location' do
    it 'returns the example value' do
      #expected = [["x", "x", "x", "x", "x", "x", "x", "x"],
      #            ["x", "x", "x", "x", "x", "x", "x", "x"],
      #            ["x", "x", "x", "x", "x", "x", "x", "x"],
      #            ["x", "x", "y", "x", "x", "x", "x", "x"],
      #            ["x", "x", "x", "x", "x", "x", "x", "x"],
      #            ["x", "x", "x", "x", "x", "x", "x", "x"],
      #            ["x", "x", "x", "x", "x", "x", "x", "x"],
      #            ["x", "x", "x", "x", "x", "x", "x", "x"]]
      row = 1
      col = 4
      location = [row, col]
      value = "e"
      subject.set_location(location, value)

      expect(subject.get_location(location)).to eq(value)
    end
  end

  describe '#add_to_capture_history' do
    it 'returns all captured pieces' do
      value = 'y'
      value2 = 'e'

      expected = ['y', 'e']
      subject.add_to_capture_history(value)
      subject.add_to_capture_history(value2)

      expect(subject.capture_history).to eq(expected)
    end
  end

  describe '#move_piece' do
    it 'moves the piece correctly' do
      expected = [["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "x", "x", "x", "x", "x"],
                  ["x", "x", "x", "P", "x", "x", "x", "x"]]

      row = 1
      col = 1
      location = [row, col]
      value = "P"

      subject.set_location(location, value)

      target_row = 7
      target_col = 3

      target_location = [target_row, target_col]

      subject.move_piece(location, target_location)

      expect(subject.get_board).to match_array(expected)
    end
  end

end