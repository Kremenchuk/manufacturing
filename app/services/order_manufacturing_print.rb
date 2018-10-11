class OrderManufacturingPrint

  def initialize(o_m_id)
    @book = WorkWithExcel.new("1.xlsx")
    @o_m = OrderManufacturing.find(o_m_id)
  end


  def prepare_print(sort_auto = false)
    # o_m_items = [id, Class, qty, print?]
    o_m_items = Array.new
    @o_m.order_manufacturings_details.each do |stillage|
      o_m_items << [stillage.item_id, stillage.item.class.to_s, stillage.qty, true]
      stillage.item.details.each do |stillage_details|
        if stillage_details[3]
          stillage_details[2] = stillage_details[2] * stillage.qty
          o_m_items << stillage_details
        else
          next
        end
      end
    end
    if sort_auto
      find_db_element(array_down_job(joining_array(o_m_items)))
    else
      find_db_element(array_down_job(o_m_items))
    end
  end


  def print(data)
    if automatic
      data = find_all_print_element(data)
    end

    # ++ Шапка
      @book.cell(0, 0, @o_m.number,{
          :font_size   => 22,
          :row_height  => 25,
          :merge_cells => {row: 0, col: 6}
      })

      # Перечень стеллажей в заказе
      next_row = 0
      @o_m.order_manufacturings_details.each_with_index do |elem, index|
        @book.cell((1 + index), 0, elem.item.name,{:font_size => 12, :row_height => 15, :merge_cells => {row: (1 + index), col: 4}})
        @book.cell((1 + index), 5, elem.qty,{:font_size => 12, :row_height => 15})
        next_row = 3 + index # Начало табличной части
      end

      @book.cell(1, 6, "Дата изготовления: #{@o_m.date}",{
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
            :merge_cells          => {row: next_row + 2, col: 0}
        })
        @book.cell(next_row, 1, 'Наименование элементов',{
            :font_size            => 11,
            :col_width            => 2,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: next_row + 2, col: 4}
        })

        @book.cell(next_row, 2, '',{:col_width => 8})
        @book.cell(next_row, 3, '',{:col_width => 8})
        @book.cell(next_row, 4, '',{:col_width => 10})

        @book.cell(next_row, 5, 'Размеры',{
            :font_size            => 11,
            :col_width            => 9,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: next_row + 2, col: 7}
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
            :merge_cells          => {row: next_row + 2, col: 8}
        })
        @book.cell(next_row, 9, 'Изготовлено',{
            :font_size            => 11,
            :col_width            => 25,
            :horizontal_alignment => 'center',
            :vertical_alignment   => 'center',
            :text_wrap            => true,
            :border               => [[:top, 'thick'], [:bottom, 'thick'], [:left, 'thick'], [:right, 'thick']],
            :merge_cells          => {row: next_row + 2, col: 9}
        })
        #++ закривання шапки таблиці
          10.times do |i|
            @book.cell(next_row + 2, i, '',{:border => [[:bottom, 'thick']]})
          end
        #-- закрівання шапки таблиці

      #-- Шапка основного тела
      next_row += 3
      data.each_with_index do |elem, index|
        size = [0,0,0]
        if elem[0].is_a? String
          elem = find_db_element(elem)
        elsif elem[0].is_a? Item
          size[0] = elem[0].size_l.present? ? elem[0].size_l : nil
          size[1] = elem[0].size_a.present? ? elem[0].size_a : nil
          size[2] = elem[0].size_b.present? ? elem[0].size_b : nil
        end

        # Визначення кольору заливки вкладених елементів
        if elem[2] > 0
          fill_color = 'c8c8c8'
        else
          fill_color = 'FFFFFF'
        end

        @book.cell(next_row + index, 0, index + 1,{
            :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :fill_color => fill_color
        })

        @book.cell(next_row + index, 1,  " " * elem[2] + elem[0].name,{
            :font_size            => 10,
            :border               => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :merge_cells          => {row: next_row + index, col: 4},
            :fill_color => fill_color
        })

        @book.cell(next_row + index, 5, size[0] != 0 ? "L=#{size[0].to_i}" : '',{
            :col_width => 6, :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :fill_color => fill_color
        })

        @book.cell(next_row + index, 6, size[1] != 0 ? "A=#{size[1].to_i}" : '',{
            :col_width => 6,:border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :fill_color => fill_color
        })

        @book.cell(next_row + index, 7, size[2] != 0 ? "B=#{size[2].to_i}" : '',{
            :col_width => 6,:border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :fill_color => fill_color
        })

        @book.cell(next_row + index, 8, elem[1],{
            :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :fill_color => fill_color
        })

        @book.cell(next_row + index, 9, '',{
            :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
            :fill_color => fill_color
        })

      end
    # ++ Основное тело

    @book.save
  end

  def find_db_element(a)
    o_m_details = Array.new
    if a[0].is_a? Array
      a.each do |elem|
        o_m_details << [elem[1].constantize.find(elem[0]), elem[2].to_f]
      end
    else
      return [a[1].constantize.find(a[0]), a[2].to_f]
    end
    return o_m_details
  end

  private

  # a = Array.new
  # data = Array.new
  # find_all_print_element(raw_data).flatten.each_with_index do |elem, index|
  #   if (index % 3) == 0 and index != 0
  #     data << a
  #     a = []
  #     a << elem
  #   else
  #     a << elem
  #   end
  # end



  def find_all_print_element(data)
    first_space = 0
    full_data = Array.new
    element_data = nil
    data.each do |first|
      full_data << (first << first_space)

      if first[0].is_a? Item
        first[0].details.each do |sec|
          if sec[1] == 'Item' and sec[3]
            element_data = find_all_print_element([find_db_element_low(sec)], first_space + 5)
          elsif sec[3]
            element = (find_db_element(sec) << first_space + 5)
            element[1] = element[1] * first[1].to_f
            element_data = element
          end
          if element_data.nil?
            next
          else
            full_data << element_data
            element_data = nil
          end
        end
      else
        full_data << (first << first_space)
      end
    end
    return full_data
  end


  def find_all_print_element_low(data, first_space = 0)
    full_data = Array.new
    element_data = nil
    data.each do |first|
      if first_space == 0
        full_data << (first << first_space)
      end
      if first[0].is_a? Item
        first[0].details.each do |sec|
          if sec[1] == 'Item' and sec[3]
            element_data = find_all_print_element([find_db_element(sec)], first_space + 5)
          elsif sec[3]
            element = (find_db_element(sec) << first_space + 5)
            element[1] = element[1] * first[1].to_f
            element_data = element
          end
          if element_data.nil?
            next
          else
            full_data << element_data
            element_data = nil
          end
        end
      else
        full_data << (first << first_space)
      end
    end
    return full_data
  end



  # підготовка для ручного об"єднання item перед друком
  def array_down_job(o_m_items_array)
    o_m_items_array_new = o_m_items_array
    if o_m_items_array.is_a? Array
      o_m_items_array.each_with_index do |elem, index|
        if elem[1] == 'Job'
          o_m_items_array_new << elem
          o_m_items_array_new.delete_at(index)
        end
      end
    end
    return o_m_items_array_new
  end

  # Автоматичне об"єднання item перед друком
  def joining_array(array_to_sort)
    sort_a = Array.new
    if array_to_sort.is_a? Array
      i = 0
      while i <= (array_to_sort.count - 1) do
        if array_to_sort[i].present?
          sort_a << array_to_sort[i]
          j = i + 1
          while j <= (array_to_sort.count - 1) do
            if array_to_sort[i][0] == array_to_sort[j][0] and array_to_sort[i][1] == array_to_sort[j][1]
              sort_a[i][2] = array_to_sort[i][2] + array_to_sort[j][2]
              array_to_sort.delete_at(j)
            end
            j += 1
          end
        end
        i += 1
      end
    end
    return sort_a
  end



end
