class OrderManufacturingPrint

  def initialize(o_m_id)
    @book = WorkWithExcel.new("1.xlsx")
    @o_m = OrderManufacturing.find(o_m_id)
  end

  def print(data)

    # ++ Шапка
      @book.cell(0, 0, @o_m.number,{
          :font_size   => 22,
          :row_height  => 25,
          :merge_cells => {row: 0, col: 6}
      })
      # Перечень стеллажей в заказе

      next_row = 0

      @o_m.order_manufacturings_details.each_with_index do |elem, index|
        @book.cell((1 + index), 0, elem.item.name,{:font_size => 12, :row_height => 15, :merge_cells => {row: (1 + index), col: 2}})
        @book.cell((1 + index), 3, elem.qty,{:font_size => 12, :row_height => 15})
        next_row = 3 + index # Начало табличной части
      end

      @book.cell(1, 5, "Дата изготовления: #{@o_m.date}",{
          :font_size    => 12,
          :row_height   => 25,
          :horizontal_alignment => 'center',
          :vertical_alignment   => 'center',
          :merge_cells  => {row: 1, col: 9}

      })
    # -- Шапка


    # ++ Основное тело
      #++ Шапка основного тела
        @book.cell(next_row, 0, '№ п/п',{
            :font_size            => 11,
            :col_width            => 6,
            :row_height           => 25,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: 6, col: 0}
        })
        @book.cell(next_row, 1, 'Наименование элементов',{
            :font_size            => 11,
            :col_width            => 2,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: 6, col: 4}
        })

        @book.cell(next_row, 2, '',{:col_width => 8})
        @book.cell(next_row, 3, '',{:col_width => 8})
        @book.cell(next_row, 4, '',{:col_width => 10})

        @book.cell(next_row, 5, 'Размеры',{
            :font_size            => 11,
            :col_width            => 5,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: 6, col: 7}
        })

        @book.cell(next_row, 6, '',{:col_width => 5})
        @book.cell(next_row, 7, '',{:col_width => 5})

        @book.cell(next_row, 8, 'Необходимо изготовить',{
            :font_size            => 11,
            :col_width            => 12,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :text_wrap            => true,
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: 6, col: 8}
        })
        @book.cell(next_row, 9, 'Изготовлено',{
            :font_size            => 11,
            :col_width            => 25,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :text_wrap            => true,
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: 6, col: 9}
        })
        # @book.cell(5, 6, 'Изготовлено',{:border => [[:right, 'thick']]})

      #-- Шапка основного тела
      next_row += 3
      data.each_with_index do |elem, index|

        @book.cell(next_row + index, 0, index + 1,{:border => [[:top, 'thin'], [:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']]})
        @book.cell(next_row + index, 1, elem[0].name,{
            :font_size            => 10,
            :col_width            => 2,
            :border               => [[:top, 'hairline'], [:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :merge_cells          => {row: next_row + index, col: 4}
        })
        @book.cell(next_row + index, 2, '',{:col_width => 8})
        @book.cell(next_row + index, 3, '',{:col_width => 8})
        @book.cell(next_row + index, 4, '',{:col_width => 10})

      end
    # ++ Основное тело

    @book.save
  end
end
