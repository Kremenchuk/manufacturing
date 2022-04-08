class OrderManufacturingPrint
  attr_reader :o_m, :book, :file_name
  attr_accessor :print_in_separate_line

  def initialize(o_m, file_name)
    @file_name = file_name
    @o_m = o_m
    @book = WorkWithExcel.new(file_name)
    @all_material = Array.new
    @print_in_separate_line = []
  end

  def print
    entities_to_print = prepare_print

    print_head

    pos = 0
    entities_to_print[:items].each do |item|
      print_hight_element(pos, item[:item], item[:qty])
      print_items_jobs((pos + 2), item)
    end


    if entities_to_print[:print_in_separate_line].present?
      entities_to_print[:print_in_separate_line].each do |item|
        print_hight_element(0, item[:item], item[:qty])
      end
    end
    print_material(entities_to_print[:materials])
    @book.save
  end

  private

  def print_items_jobs(pos, item_job)
    if item_job[:jobs].present?
      item_job[:jobs].each do |job|
        print_low_element((pos + 4), job[:entity], job[:qty])
      end
    end
    if item_job[:items].present?
      item_job[:items].each do |item|
        print_low_element((pos + 4), item[:item], item[:qty])
        print_items_jobs((pos + 4), item )
      end
    end
  end

  def print_head
    # ++ Шапка
    @book.cell(0, 0, @o_m.number,{
        :font_size   => 22,
        :row_height  => 25,
        :merge_cells => {row: 0, col: 6}
    })

    # Перечень стеллажей в заказе
    @next_row = 0
    @o_m.order_manufacturings_details.each_with_index do |elem, index|
      @book.cell((1 + index), 1, elem.item.name,{
          :font_size => 12,
          :row_height => 15,
          :merge_cells => {row: (1 + index), col: 4},
          # :horizontal_alignment => 'center',
          :vertical_alignment   => 'center'
      })
      @book.cell((1 + index), 5, elem.qty,{
          :font_size => 12,
          :row_height => 15,
          :horizontal_alignment => 'center',
          :vertical_alignment   => 'center'
      })
      @next_row = 3 + index # Начало табличной части
    end

    @book.cell(1, 6, "Дата изготовления: #{@o_m.finish_date}",{
        :font_size    => 12,
        :row_height   => 25,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :merge_cells  => {row: 1, col: 9}

    })
    # -- Шапка


    # ++ Основное тело
    #++ Шапка основного тела
    # @book.cell(@next_row, 0, '№ п/п',{
    #     :font_size            => 11,
    #     :col_width            => 6,
    #     :row_height           => 25,
    #     :horizontal_alignment => 'center',
    #     :vertical_alignment   => 'center',
    #     :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
    #     :merge_cells          => {row: @next_row + 2, col: 0}
    # })
    @book.cell(@next_row, 0, I18n.t('o_m_print_excel.head.elements_name'),{
        :font_size            => 11,
        :col_width            => 15,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 3}
    })

    @book.cell(@next_row, 1, '',{:col_width => 8})
    @book.cell(@next_row, 2, '',{:col_width => 8})
    @book.cell(@next_row, 3, '',{:col_width => 10})

    @book.cell(@next_row, 4, I18n.t('o_m_print_excel.head.value'),{
        :font_size            => 11,
        :col_width            => 9,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 6}
    })

    @book.cell(@next_row, 5, '',{:col_width => 5})
    @book.cell(@next_row, 6, '',{:col_width => 5})

    @book.cell(@next_row, 7, I18n.t('o_m_print_excel.head.need_produce'),{
        :font_size            => 11,
        :col_width            => 12,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :text_wrap            => true,
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 7}
    })
    @book.cell(@next_row, 8, I18n.t('all_form.unit_short'),{
        :font_size            => 11,
        :col_width            => 6,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :text_wrap            => true,
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 8}
    })
    @book.cell(@next_row, 9, I18n.t('o_m_print_excel.head.produced'),{
        :font_size            => 11,
        :col_width            => 15,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :text_wrap            => true,
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 9}
    })
    #++ закривання шапки таблиці
    @next_row +=2
    10.times do |i|
      @book.cell(@next_row, i, '',{:border => [[:bottom, 'medium']]})
    end
    #-- закривання шапки таблиці

    #-- Шапка основного тела
  end


  def print_hight_element(pos, elem, qty)
    @next_row += 1
    fill_color = 'FFFFFF'
    text_to_cell = elem.name
    @book.cell(@next_row, 0,  text_to_cell ,{
        :font_size            => 10,
        :border               => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :merge_cells          => {row: @next_row, col: 4},
        :fill_color => fill_color
    })
    size_l = elem.size_l.present? ? "L=#{elem.size_l.to_i}" : ''
    size_a = elem.size_a.present? ? "A=#{elem.size_a.to_i}" : ''
    size_b = elem.size_b.present? ? "B=#{elem.size_b.to_i}" : ''

    @book.cell(@next_row, 4, size_l,{
        :col_width => 6,
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    @book.cell(@next_row, 5, size_a,{
        :col_width => 6,
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    @book.cell(@next_row, 6, size_b,{
        :col_width => 6,
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    @book.cell(@next_row, 7, qty,{
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    @book.cell(@next_row, 8, '',{
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :horizontal_alignment => 'center',
        :fill_color => fill_color
    })

    @book.cell(@next_row, 9, '',{
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

  end

  def print_low_element(pos, elem, qty)
    @next_row += 1
    if elem.is_a? Item
      size_l = elem.size_l.to_i != 0 ? "L=#{elem.size_l.to_i}" : ''
      size_a = elem.size_a.to_i != 0 ? "A=#{elem.size_a.to_i}" : ''
      size_b = elem.size_b.to_i != 0 ? "B=#{elem.size_b.to_i}" : ''
    end
    # # Визначення кольору заливки вкладених елементів
    if elem.is_a? Item
      fill_color = 'FFFFFF'
    else
      fill_color = 'AFAFAF'
    end
    # @book.cell(@next_row, 0, @next_row - 6,{
    #     :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
    #     :fill_color => fill_color
    # })

    if elem.is_a? Job
      text_to_cell = elem.name_for_print
    else
      text_to_cell = elem.name
    end
    @book.cell(@next_row, 0,  " " * pos + text_to_cell,{
        :font_size            => 10,
        :border               => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :merge_cells          => {row: @next_row, col: 4},
        :fill_color => fill_color
    })

    @book.cell(@next_row, 4, size_l,{
        :col_width => 6,
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    @book.cell(@next_row, 5, size_a,{
        :col_width => 6,
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    @book.cell(@next_row, 6, size_b,{
        :col_width => 6,
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    @book.cell(@next_row, 7, qty,{
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    if elem.is_a? Job
      text_to_cell = ''
    else
      text_to_cell = elem.unit
    end
    @book.cell(@next_row, 8, text_to_cell,{
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :horizontal_alignment => 'center',
        :fill_color => fill_color
    })

    @book.cell(@next_row, 9, '',{
        :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
        :fill_color => fill_color
    })

    # -- Основное тело
  end


  def print_material(materials)
    @next_row += 1

    @book.cell(@next_row, 0, I18n.t('o_m_print_excel.head.used_materials'),{
        :font_size            => 14,
        :col_width            => 6,
        :row_height           => 25,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :merge_cells    => {row: @next_row, col: 4}
    })

    materials.each do |material|
      @next_row += 1
      @book.cell(@next_row, 0,material[0].name,{
          :merge_cells    => {row: @next_row, col: 4}
      })
      @book.cell(@next_row, 5,material[1],{

      })
      @book.cell(@next_row, 6,material[0].unit,{

      })
    end
  end

  private

  def prepare_print
    items = []

    o_m.order_manufacturings_details.each do |o_m_detail|
      items.concat(print_items(o_m_detail.item, o_m_detail.qty))
    end

    {
      items: items,
      materials: o_m.used_materials,
      print_in_separate_line: print_in_separate_line
    }
  end

  def print_items(item, qty)
    items = []
    item_hash = {
      item: item,
      qty: qty }
    jobs_in_item = item.item_jobs(true, qty)
    item_hash[:jobs] = jobs_in_item if jobs_in_item.present?

    item.item_items.each do |item_detail|
      if item_detail[:print_in_o_m]
        if item_detail[:entity].print_in_collection
          item_hash[:items] = [] unless item_hash[:items].present?
          item_hash[:items].concat(print_items(item_detail[:entity], (item_detail[:qty] * qty)))
        else
          print_in_separate_line << {
            item: item_detail[:entity],
            qty: (item_detail[:qty] * qty) }
        end
      end
    end
    items << item_hash
    items
  end
end
