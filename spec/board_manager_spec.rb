require_relative '../lib/board/board_manager'
describe Board_Manager do
  subject { Board_Manager.new }

  describe '#get_board' do
    it 'returns the correct default board' do
      expected = [%w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x]]

      expect(subject.get_board).to match_array(expected)
    end
  end

  describe '#set_location' do
    it 'sets location row 3, col 2' do
      expected = [%w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x y x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x]]

      row = 3
      col = 2
      location = [row, col]
      value = 'y'
      subject.set_location(location, value)

      expect(subject.get_board).to match_array(expected)
    end
  end

  describe '#delete_location' do
    it 'sets the target to nil' do
      expected = [%w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  ['x', 'x', 'x', 'x', 'x', nil, 'x', 'x'],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x]]

      row = 5
      col = 5
      location = [row, col]

      subject.delete_location(location)

      expect(subject.get_board).to match_array(expected)
    end
  end

  describe '#get_location' do
    it 'returns the example value' do
      # expected = [["x", "x", "x", "x", "x", "x", "x", "x"],
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
      value = 'e'
      subject.set_location(location, value)

      expect(subject.get_location(location)).to eq(value)
    end
  end

  describe '#add_to_capture_history' do
    it 'returns all captured pieces' do
      value = 'y'
      value2 = 'e'

      expected = %w[y e]
      subject.add_to_capture_history(value)
      subject.add_to_capture_history(value2)

      expect(subject.capture_history).to eq(expected)
    end
  end

  describe '#move_piece' do
    it 'moves the piece correctly' do
      expected = [%w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x x x x x x],
                  %w[x x x P x x x x]]

      row = 1
      col = 1
      location = [row, col]
      value = 'P'

      subject.set_location(location, value)

      target_row = 7
      target_col = 3

      target_location = [target_row, target_col]

      subject.move_piece(location, target_location)

      expect(subject.get_board).to match_array(expected)
    end
  end

  describe '#get_threatend_squares' do
    subject { Board_Manager.new }

    context 'empty board' do
      it 'white returns no threatend squares' do
        expect(subject.get_threatend_squares('white')).to be_empty
        # expect(subject.get_threatend_squares('black')).to be_empty
      end

      it 'black returns no threatend squares' do
        # expect(subject.get_threatend_squares('white')).to be_empty
        expect(subject.get_threatend_squares('black')).to be_empty
      end
    end

    context 'default baord' do
    end
  end

  describe '#setup_board' do
    subject { Board_Manager.new }

    context 'empty to default board' do
      # has an extra newline, not really needed but looks nicer
      it 'returns the correct default layout' do
        expected_out = <<~OUTPUT

          R N B Q K B N R
          P P P P P P P P
          x x x x x x x x
          x x x x x x x x
          x x x x x x x x
          x x x x x x x x
          P P P P P P P P
          R N B Q K B N R
        OUTPUT

        subject.setup_board
        expect { subject.draw_board }.to output(expected_out).to_stdout
      end
    end
  end
end
