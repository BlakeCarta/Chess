module Input_Manager
  def self.get_input
    target = [3, 0]
    current = [1, 1]
    [target, current]
  end

  def self.convert_posistion_to_row_col(input_text)
    columns = { 'a': 0, 'b': 1, 'c': 2, 'd': 3, 'e': 4, 'f': 5, 'g': 6, 'h': 7 }
    column = columns[input_text[0]&.downcase&.to_sym]
    row = input_text[1]&.to_i&.- 1

    return nil if column.nil? || row.nil? || !row.between?(0, 7)

    [row, column]
  end
end
