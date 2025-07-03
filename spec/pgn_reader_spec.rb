require './lib/pgn_reader.rb'
require './lib/custom_data.rb'

describe PgnReader do
  context '#initialize' do
    subject(:defualt_parser) { described_class.new }
    it 'selects correct defualt file' do
      expect(subject.filename).to eq('example_input')
    end
  end

  # no longer needed, refactor or delete later
  context '#read_example_file' do
    subject(:example_reader) { described_class.new }
    xit 'correctly reads the example file' do
      example_expected_output = ['[Event "F/S Return Match"]',
                                 '["Site "Belgrade, Serbia JUG""]',
                                 '[Date "1992.11.04"]',
                                 '[Round "29"]',
                                 '[White "Fischer, Robert J."]',
                                 '[Black "Spassky, Boris V."]',
                                 '[Result "1/2-1/2"]',
                                 '[1.e4 e5 2.Nf3 Nc6 3.Bb5 {This opening is called the Ruy Lopez.} 3...a6]',
                                 '[4.Ba4 Nf6 5.O-O Be7 6.Re1 b5 7.Bb3 d6 8.c3 O-O 9.h3 Nb8 10.d4 Nbd7]',
                                 '[11.c4 c6 12.cxb5 axb5 13.Nc3 Bb7 14.Bg5 b4 15.Nb1 h6 16.Bh4 c5 17.dxe5]',
                                 '[Nxe4 18.Bxe7 Qxe7 19.exd6 Qf6 20.Nbd2 Nxd6 21.Nc4 Nxc4 22.Bxc4 Nb6]',
                                 '[23.Ne5 Rae8 24.Bxf7+ Rxf7 25.Nxf7 Rxe1+ 26.Qxe1 Kxf7 27.Qe3 Qg5 28.Qxg5]',
                                 '[hxg5 29.b3 Ke6 30.a3 Kd6 31.axb4 cxb4 32.Ra5 Nd5 33.f3 Bc8 34.Kf2 Bf5]',
                                 '[35.Ra7 g6 36.Ra6+ Kc5 37.Ke1 Nf4 38.g3 Nxh3 39.Kd2 Kb5 40.Rd6 Kc5 41.Ra6]',
                                 '[Nf2 42.g4 Bd3 43.Re6 1/2-1/2]']
      expect(subject.read_example_file).to eq(example_expected_output)
    end
  end

  context '#breakup_lines' do
    subject(:example_breakup_line) { described_class.new }
    it 'seperates the string into chunks' do
      example_line = %q[1.e4 e5 2.Nf3 Nc6 3.Bb5 {This opening is called the Ruy Lopez.} 3...a6]
      example_result_line = ["1.e4", "e5", "2.Nf3", "Nc6", "3.Bb5", "{This", "opening", "is", "called", "the", "Ruy", "Lopez.}", "3...a6"]
      expect(subject.breakup_lines(example_line)).to eq(example_result_line)
    end
  end

  context '#extract_turn_data' do
    subject(:example_extracted_turn_data) { described_class.new }
    it 'correctly retrieves the 1st row turn data from broken apart lines' do
      #example_input = ["1.e4", "e2", "2.Nf3", "Nc6", "3.Bb5", "{This opening is called the Ruy Lopez.}", "3...a6"]
      example_input = ["1.e4", "e5", "2.Nf3", "Nc6", "3.Bb5", "{This", "opening", "is", "called", "the", "Ruy", "Lopez.}", "3...a6"]
      turn_1 = CustomData.new(1, "e4", "e5")
      turn_2 = CustomData.new(2, "Nf3", "Nc6")
      turn_3 = CustomData.new(3, "Bb5", "a6", "This opening is called the Ruy Lopez.")
      expected_turn_data = [turn_1, turn_2, turn_3]
      expect(subject.extract_turn_data(example_input)).to full_equivalent_of(expected_turn_data)
    end

    it 'correctly handles the special characters in the 2nd row data' do
      second_row_example_input = ["4.Ba4", "Nf6", "5.O-O", "Be7", "6.Re1", "b5", "7.Bb3", "d6", "8.c3", "O-O", "9.h3", "Nb8", "10.d4", "Nbd7"]
      turn_4 = CustomData.new(4, "Ba4", "Nf6")
      turn_5 = CustomData.new(5, "O-O", "Be7")
      turn_6 = CustomData.new(6, "Re1", "b5")
      turn_7 = CustomData.new(7, "Bb3", "d6")
      turn_8 = CustomData.new(8, "c3", "O-O")
      turn_9 = CustomData.new(9, "h3", "Nb8")
      turn_10 = CustomData.new(10, "d4", "Nbd7")
      expected_turn_data = [nil, nil, nil, nil, turn_4, turn_5, turn_6, turn_7, turn_8, turn_9, turn_10]
      expect(subject.extract_turn_data(second_row_example_input)).to full_equivalent_of(expected_turn_data)
    end
  end
  
  context '#read_multiple_lines' do
    subject(:example_multiple_line_reader) { described_class.new }
    it 'extracts the data correctly from multiple lines' do
      multi_line_input = ['11.c4 c6 12.cxb5 axb5 13.Nc3 Bb7 14.Bg5 b4 15.Nb1 h6 16.Bh4 c5 17.dxe5',
              'Nxe4 18.Bxe7 Qxe7 19.exd6 Qf6 20.Nbd2 Nxd6 21.Nc4 Nxc4 22.Bxc4 Nb6']
      turn_11 = CustomData.new(11, "c4", "c6")
      turn_12 = CustomData.new(12, "cxb5", "axb5")
      turn_13 = CustomData.new(13, "Nc3", "Bb7")
      turn_14 = CustomData.new(14, "Bg5", "b4")
      turn_15 = CustomData.new(15, "Nb1", "h6")
      turn_16 = CustomData.new(16, "Bh4", "c5")
      turn_17 = CustomData.new(17, "dxe5", "Nxe4")
      turn_18 = CustomData.new(18, "Bxe7", "Qxe7")
      turn_19 = CustomData.new(19, "exd6", "Qf6")
      turn_20 = CustomData.new(20, "Nbd2", "Nxd6")
      turn_21 = CustomData.new(21, "Nc4", "Nxc4")
      turn_22 = CustomData.new(22, "Bxc4", "Nb6")
      expected_output = [nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, turn_11, turn_12, turn_13, turn_14, turn_15, turn_16, turn_17, turn_18, turn_19, turn_20, turn_21]
      expect(subject.extract_turn_data(multi_line_input)).to full_equivalent_of(expected_output)
    end

    subject(:example_multiple_line_reader) { described_class.new }
    it 'extracts the data correctly from the ending lines with special characters' do
      multi_line_input = ['35.Ra7 g6 36.Ra6+ Kc5 37.Ke1 Nf4 38.g3 Nxh3 39.Kd2 Kb5 40.Rd6 Kc5 41.Ra6
                           Nf2 42.g4 Bd3 43.Re6 1/2-1/2']
      expected_output = Array.new(43)
      expected_output[35] = CustomData.new(35, "Ra7", "g6")
      expected_output[36] = CustomData.new(36, "Ra6+", "Kc5")
      expected_output[37] = CustomData.new(37, "Ke1", "Nf4")
      expected_output[38] = CustomData.new(38, "g3", "Nxh3")
      expected_output[39] = CustomData.new(39, "Kd2", "Kb5")
      expected_output[40] = CustomData.new(40, "Rd6", "Kc5")
      expected_output[41] = CustomData.new(41, "Ra6", "Nf2")
      expected_output[42] = CustomData.new(42, "g4", "Bd3")
      expected_output[43] = CustomData.new(43, "Re6")
      expect(subject.extract_turn_data(multi_line_input)).to full_equivalent_of(expected_output)
    end
  end

  context '#get_headers' do
    it 'extracts all headers from the example file' do
        input = ['[Event "F/S Return Match"]',
                 '[Site "Belgrade, Serbia JUG"]',
                 '[Date "1992.11.04"]',
                 '[Round "29"]',
                 '[White "Fischer, Robert J."]',
                 '[Black "Spassky, Boris V."]',
                 '[Result "1/2-1/2"]']
        #expected_result = ['Event "F/S Return Match"','Site "Belgrade, Serbia JUG"','Date "1992.11.04"','Round "29"','White "Fischer, Robert J."','Black "Spassky, Boris V."','Result "1/2-1/2"']
        expected_result = {Event: "F/S Return Match", Site: "Belgrade, Serbia JUG", Date: "1992.11.04", Round: "29", White: "Fischer, Robert J.", Black: "Spassky, Boris V.", Result: "1/2-1/2"}
        expect(subject.get_headers(input)).to eq(expected_result)
    end
  end

  context '#set_header' do
    it 'sets hash correctly' do
      key = 'Event'
      data = "F/S Return Match"
      example = {Event: "F/S Return Match"}
      expect(subject.set_header(key,data)).to eq(example[:Event])
    end
  end
end