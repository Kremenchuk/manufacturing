class WorkWithExcel

  def initialize(file_path)
    @file_path = file_path
    @book = RubyXL::Workbook.new
    @sheet = @book[0]
  end

  def file_name
    @file_path
  end

  def sheet(number = 0)
    @sheet = @book[number]
  end

  def cell(row, col, value, options = {})
    @sheet.add_cell(row, col, value)

    options[:font_size].present?              ? @sheet[row][col].change_font_size(options[:font_size])          : nil
    options[:row_height].present?             ? @sheet.change_row_height(row, options[:row_height])             : nil
    options[:col_width].present?              ? @sheet.change_column_width(col, options[:col_width])            : nil
    options[:text_wrap].present?              ? @sheet[row][col].change_text_wrap(options[:text_wrap])          : nil
    options[:horizontal_alignment].present?   ? horizontal_alignment(row, col, options[:horizontal_alignment])  : nil #center, distributed, justify, left, right
    options[:vertical_alignment].present?     ? vertical_alignment(row, col, options[:vertical_alignment])      : nil #bottom, center, distributed, top
    options[:border].present?                 ? border(row, col, options[:border])                              : nil #top, bottom, left, right, diagonal (hairline, thin, medium, thick)
    options[:merge_cells].present?            ? merge_cells(row, col, options[:merge_cells])                    : nil
    options[:fill_color].present?             ? @sheet[row][col].change_fill(options[:fill_color])              : nil
  end

  def save(file_path = nil)
    if file_path.present?
      @book.write file_path
    else
      @book.write @file_path
    end
  end

  private

  def horizontal_alignment(row, col, options)
    # center, distributed, justify, left, right
    @sheet.sheet_data[row][col].change_horizontal_alignment(options)
  end

  def vertical_alignment(row, col, options)
    # bottom, center, distributed, top
    @sheet.sheet_data[row][col].change_vertical_alignment(options)
  end

  def border(row, col, options = {})
    # Possible weights: hairline, thin, medium, thick
    # Possible "directions": top, bottom, left, right, diagonal
    options.each do |key, value|
      @sheet.sheet_data[row][col].change_border(key, value)
    end
  end

  def merge_cells(row1, col1, options = {})
    @sheet.merge_cells(row1, col1, options[:row], options[:col])
  end

end

