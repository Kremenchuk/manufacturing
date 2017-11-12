class WorkWithExcel

  def initialize(file_path)
    @file_path = file_path
    @book = RubyXL::Workbook.new
    @sheet = @book[0]
  end

  def sheet(number = 0)
    @sheet = @book[number]
  end

  def cell(row, col, value, options = {})
    @sheet.add_cell(row, col, value)

    options[:font_size].present?  ? @sheet[row][col].change_font_size(options[:font_size]) : nil
    options[:row_height].present? ? @sheet.change_row_height(row, options[:row_height])    : nil
    options[:border].present?     ? border(row, col, options[:border])                     : nil
  end

  def save(file_path = nil)
    if file_path.present?
      @book.write file_path
    else
      @book.write @file_path
    end
  end

  def border(row, col, options = {})
    # Possible weights: hairline, thin, medium, thick
    # Possible "directions": top, bottom, left, right, diagonal
    options.each do |key, value|
      @sheet.sheet_data[row][col].change_border(key, value)
    end
  end


end

