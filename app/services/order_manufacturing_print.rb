class OrderManufacturingPrint

  def initialize(o_m_id)
    @book = WorkWithExcel.new("1.xlsx")
    @o_m = OrderManufacturing.find(o_m_id)
  end

  def print

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

      o_m_details = search_same
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

  private

  def search_same(item_id = nil, s_kol = nil)
    items = Array.new
    if item_id.nil?
      @o_m.order_manufacturings_details.each do |stillage|
        s_kol = stillage.qty
        s_details = stillage.details

      end
    end
    return items
  end

end
