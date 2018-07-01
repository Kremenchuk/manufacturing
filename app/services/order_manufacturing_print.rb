class OrderManufacturingPrint

  def initialize(o_m_id)
    @book = WorkWithExcel.new("1.xlsx")
    @o_m = OrderManufacturing.find(o_m_id)
  end

  def print(data)

    # ++ Шапка
      @book.cell(0, 0, @o_m.number,
                      {
                          :font_size => 15,
                          :row_height => 25,
                          :border => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
                          :merge_cells => [0, 6]
                      })
      @book.cell(0, 6, '',{:border => [[:right, 'thick']]})

      @book.cell(0, 10, @o_m.date,
                 {
                     :font_size => 15,
                     :border => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
                     :merge_cells => [0, 12]
                 })
      @book.cell(0, 12, '',{:border => [[:right, 'thick']]})
    # -- Шапка


    # ++ Основное тело
      @book.cell(2, 0, @o_m.date,
                 {
                     :font_size => 15,
                     :border => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
                     :merge_cells => [0, 12]
                 })


    # ++ Основное тело

    @book.save
  end
end
