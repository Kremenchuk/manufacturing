class OrderManufacturingPrint

  def initialize(o_m_id)
    @o_m = OrderManufacturing.find(o_m_id)
    @book = WorkWithExcel.new("#{@o_m.number.to_s}" + ".xlsx")
    @all_material = Array.new
  end

  # def prepare_print(auto_print = false)
  #   # o_m_items = [id, Class, qty, print?]
  #   o_m_items = Array.new
  #   @o_m.order_manufacturings_details.each do |stillage|
  #     # o_m_items << [stillage, stillage.qty, true]
  #     stillage.item.details.each do |stillage_details|
  #       if stillage_details[3]
  #         stillage_details[2] = stillage_details[2] * stillage.qty
  #         o_m_items << find_db_element(stillage_details)
  #       else
  #         next
  #       end
  #     end
  #   end
  #   if auto_print
  #     return array_down_job(joining_array(o_m_items))
  #   else
  #     return array_down_job(o_m_items)
  #   end
  # end

  def file_name
    @book.file_name
  end


  def print
    # data = find_all_print_element(data)
    print_head

    @o_m.order_manufacturings_details.each do |stillage|
      # o_m_items << [stillage, stillage.qty, true]
      stillage.item.details.each do |stillage_details|
        if stillage_details[3]
          @next_row +=1
          print_low_element(0, stillage_details, stillage_details[2] * stillage.qty)
        else
          next
        end
      end
    end

    print_material
    @book.save
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
          :horizontal_alignment => 'center',
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
    @book.cell(@next_row, 0, 'Наименование элементов',{
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

    @book.cell(@next_row, 4, 'Размеры',{
        :font_size            => 11,
        :col_width            => 9,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 6}
    })

    @book.cell(@next_row, 5, '',{:col_width => 5})
    @book.cell(@next_row, 6, '',{:col_width => 5})

    @book.cell(@next_row, 7, 'Необходимо изготовить',{
        :font_size            => 11,
        :col_width            => 12,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :text_wrap            => true,
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 7}
    })
    @book.cell(@next_row, 8, 'Ед. изм.',{
        :font_size            => 11,
        :col_width            => 6,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :text_wrap            => true,
        :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
        :merge_cells          => {row: @next_row + 2, col: 8}
    })
    @book.cell(@next_row, 9, 'Изготовлено',{
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


  def print_low_element(pos, elem, qty)

    if elem[3]
      @next_row += 1
      elem = find_db_element(elem)
      if elem[0].is_a? Material
        @all_material << [elem[0], qty]
      end

      if elem[0].is_a? Item
        size_l = elem[0].size_l.to_i != 0 ? "L=#{elem[0].size_l.to_i}" : ''
        size_a = elem[0].size_a.to_i != 0 ? "A=#{elem[0].size_a.to_i}" : ''
        size_b = elem[0].size_b.to_i != 0 ? "B=#{elem[0].size_b.to_i}" : ''
      end
      # # Визначення кольору заливки вкладених елементів
      if pos == 0
        fill_color = 'AFAFAF'
      else
        fill_color = 'FFFFFF'
      end

      # @book.cell(@next_row, 0, @next_row - 6,{
      #     :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
      #     :fill_color => fill_color
      # })

      if elem[0].is_a? Job
        text_to_cell = elem[0].name_for_print
      else
        text_to_cell = elem[0].name
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

      if elem[0].is_a? Job
        text_to_cell = ''
      else
        text_to_cell = elem[0].unit
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

      if elem[0].is_a? Item
        pos += 4
        elem[0].details.each do |item_details|
          print_low_element(pos, item_details, item_details[2] * qty)
        end
      end
    else
      elem = find_db_element(elem)
      if elem[0].is_a? Material
        @all_material << [elem[0], qty]
      end
    end
  end


  def print_material
    sum_material = Array.new
    @next_row += 1

    @book.cell(@next_row, 0, 'Необходимые материалы',{
        :font_size            => 14,
        :col_width            => 6,
        :row_height           => 25,
        :horizontal_alignment => 'center',
        :vertical_alignment   => 'center',
        :merge_cells    => {row: @next_row, col: 4}
    })


    # Сумування однакових матеріалів

    for i in 0..(@all_material.size - 1)
      if @all_material[i].nil?
        next
      else
        mat_qty = @all_material[i][1]
      end
      for j in (i+1)..(@all_material.size - 1)
        if @all_material[i].present? and @all_material[j].present?
          if @all_material[i][0].id == @all_material[j][0].id
            mat_qty = @all_material[i][1] + @all_material[j][1]
            @all_material[j] = nil
          end
        end
      end
      sum_material << [@all_material[i][0], mat_qty]
    end


    sum_material.each do |material|
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

  def find_db_element(a)
    o_m_details = Array.new
    begin
    if a[0].is_a? Array
      a.each do |elem|
        o_m_details << [elem[1].constantize.find(elem[0]), elem[2].to_f]
      end
    else
      return [a[1].constantize.find(a[0]), a[2].to_f]
    end
    rescue => error

    end

    return o_m_details
  end

  private
  #
  #
  # def find_all_print_element(data)
  #   full_data = Array.new
  #   data.each do |first|
  #     full_data << (first << 0)
  #     if first[0].is_a? Item
  #       first[0].details.each do |second|
  #         if second[1] == 'Item' and second[3]
  #           element = (find_db_element(second) << 5)
  #           element[1] = element[1] * first[1].to_f
  #           full_data << element
  #           full_data = find_all_print_element_low(full_data, second, (first[1] * second[2]),5)
  #         elsif second[3]
  #           element = (find_db_element(second) << 5)
  #           element[1] = element[1] * first[1].to_f
  #           full_data << element
  #         end
  #       end
  #     end
  #   end
  #   return full_data
  # end

  #
  # def find_all_print_element_low(full_data, first, qty,first_space = 0)
  #     if first[0].is_a? Item
  #       first[0].details.each do |second|
  #         if second[1] == 'Item' and second[3]
  #           element = (find_db_element(second) << first_space)
  #           element[1] = element[1] * first[1].to_f
  #           full_data << element
  #           full_data = find_all_print_element_low(full_data, second, (qty * second[2]),(first_space + 5))
  #         elsif second[3]
  #           element = (find_db_element(second) << first_space + 5)
  #           element[1] = element[1] * first[1].to_f
  #           full_data << element
  #         end
  #       end
  #     elsif first[0].is_a? Job or first[0].is_a? Material
  #       full_data << (first << 0)
  #     # else
  #     #   full_data << (first << 0)
  #     end
  #   return full_data
  # end
  #
  # # підготовка для ручного об"єднання item перед друком
  # def array_down_job(o_m_items_array)
  #   # o_m_items_array_new = o_m_items_array
  #   o_m_items_job_array = Array.new
  #   o_m_items_item_array = Array.new
  #   if o_m_items_array.is_a? Array
  #     o_m_items_array.each_with_index do |elem, index|
  #       if elem[0].is_a? Job
  #         o_m_items_job_array << elem
  #         # o_m_items_array_new.delete_at(index)
  #       elsif elem[0].is_a? Item
  #         o_m_items_item_array << elem
  #       end
  #     end
  #   end
  #   o_m_items_item_array.sort_by! {|elem| elem[0].item_group.range}
  #   return o_m_items_item_array + o_m_items_job_array
  # end
  #
  #
  # # Автоматичне об"єднання item з ордеру у виробництво перед друком
  # def joining_array(array_to_sort)
  #   sort_a = Array.new
  #   if array_to_sort.is_a? Array
  #     i = 0
  #     while i <= (array_to_sort.count - 1) do
  #       if array_to_sort[i].present?
  #         sort_a << array_to_sort[i]
  #         j = i + 1
  #         while j <= (array_to_sort.count - 1) do
  #           if array_to_sort[i][0] == array_to_sort[j][0]
  #             sort_a[i][1] = array_to_sort[i][1] + array_to_sort[j][1]
  #             array_to_sort.delete_at(j)
  #           end
  #           j += 1
  #         end
  #       end
  #       i += 1
  #     end
  #   end
  #   return sort_a
  # end

end


# def print(data)
#   data = find_all_print_element(data)
#
#   # ++ Шапка
#     @book.cell(0, 0, @o_m.number,{
#         :font_size   => 22,
#         :row_height  => 25,
#         :merge_cells => {row: 0, col: 6}
#     })
#
#     # Перечень стеллажей в заказе
#     next_row = 0
#     @o_m.order_manufacturings_details.each_with_index do |elem, index|
#       @book.cell((1 + index), 1, elem.item.name,{:font_size => 12, :row_height => 15, :merge_cells => {row: (1 + index), col: 4}})
#       @book.cell((1 + index), 5, elem.qty,{:font_size => 12, :row_height => 15})
#       next_row = 3 + index # Начало табличной части
#     end
#
#     @book.cell(1, 6, "Дата изготовления: #{@o_m.date}",{
#         :font_size    => 12,
#         :row_height   => 25,
#         :horizontal_alignment => 'center',
#         :vertical_alignment   => 'center',
#         :merge_cells  => {row: 1, col: 9}
#
#     })
#   # -- Шапка
#
#
#   # ++ Основное тело
#     #++ Шапка основного тела
#       @book.cell(next_row, 0, '№ п/п',{
#           :font_size            => 11,
#           :col_width            => 6,
#           :row_height           => 25,
#           :horizontal_alignment => 'center',
#           :vertical_alignment   => 'center',
#           :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
#           :merge_cells          => {row: next_row + 2, col: 0}
#       })
#       @book.cell(next_row, 1, 'Наименование элементов',{
#           :font_size            => 11,
#           :col_width            => 12,
#           :horizontal_alignment => 'center',
#           :vertical_alignment   => 'center',
#           :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
#           :merge_cells          => {row: next_row + 2, col: 4}
#       })
#
#       @book.cell(next_row, 2, '',{:col_width => 8})
#       @book.cell(next_row, 3, '',{:col_width => 8})
#       @book.cell(next_row, 4, '',{:col_width => 10})
#
#       @book.cell(next_row, 5, 'Размеры',{
#           :font_size            => 11,
#           :col_width            => 9,
#           :horizontal_alignment => 'center',
#           :vertical_alignment   => 'center',
#           :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
#           :merge_cells          => {row: next_row + 2, col: 7}
#       })
#
#       @book.cell(next_row, 6, '',{:col_width => 5})
#       @book.cell(next_row, 7, '',{:col_width => 5})
#
#       @book.cell(next_row, 8, 'Необходимо изготовить',{
#           :font_size            => 11,
#           :col_width            => 12,
#           :horizontal_alignment => 'center',
#           :vertical_alignment   => 'center',
#           :text_wrap            => true,
#           :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
#           :merge_cells          => {row: next_row + 2, col: 8}
#       })
#       @book.cell(next_row, 9, 'Ед. изм.',{
#           :font_size            => 11,
#           :col_width            => 6,
#           :horizontal_alignment => 'center',
#           :vertical_alignment   => 'center',
#           :text_wrap            => true,
#           :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
#           :merge_cells          => {row: next_row + 2, col: 9}
#       })
#       @book.cell(next_row, 10, 'Изготовлено',{
#           :font_size            => 11,
#           :col_width            => 15,
#           :horizontal_alignment => 'center',
#           :vertical_alignment   => 'center',
#           :text_wrap            => true,
#           :border               => [[:top, 'medium'], [:bottom, 'medium'], [:left, 'medium'], [:right, 'medium']],
#           :merge_cells          => {row: next_row + 2, col: 10}
#       })
#       #++ закривання шапки таблиці
#         11.times do |i|
#           @book.cell(next_row + 2, i, '',{:border => [[:bottom, 'medium']]})
#         end
#       #-- закрівання шапки таблиці
#
#     #-- Шапка основного тела
#
#
#     next_row += 3
#     data.each_with_index do |elem, index|
#       size = [0,0,0]
#       if elem[0].is_a? String
#         elem = find_db_element(elem)
#       elsif elem[0].is_a? Item
#         size[0] = elem[0].size_l.present? ? elem[0].size_l : nil
#         size[1] = elem[0].size_a.present? ? elem[0].size_a : nil
#         size[2] = elem[0].size_b.present? ? elem[0].size_b : nil
#       end
#
#       # Визначення кольору заливки вкладених елементів
#       if elem[2] > 0
#         fill_color = 'AFAFAF'
#       else
#         fill_color = 'FFFFFF'
#       end
#
#       @book.cell(next_row + index, 0, index + 1,{
#           :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :fill_color => fill_color
#       })
#
#       @book.cell(next_row + index, 1,  " " * elem[2] + elem[0].name,{
#           :font_size            => 10,
#           :border               => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :merge_cells          => {row: next_row + index, col: 4},
#           :fill_color => fill_color
#       })
#
#       @book.cell(next_row + index, 5, size[0].to_i != 0 ? "L=#{size[0].to_i}" : '',{
#           :col_width => 6,
#           :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :fill_color => fill_color
#       })
#
#       @book.cell(next_row + index, 6, size[1].to_i != 0 ? "A=#{size[1].to_i}" : '',{
#           :col_width => 6,
#           :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :fill_color => fill_color
#       })
#
#       @book.cell(next_row + index, 7, size[2].to_i != 0 ? "B=#{size[2].to_i}" : '',{
#           :col_width => 6,
#           :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :fill_color => fill_color
#       })
#
#       @book.cell(next_row + index, 8, elem[1],{
#           :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :fill_color => fill_color
#       })
#
#       if elem[0].is_a? Job
#         text_to_cell = ''
#       else
#         text_to_cell = elem[0].unit
#       end
#       @book.cell(next_row + index, 9, text_to_cell,{
#           :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :horizontal_alignment => 'center',
#           :fill_color => fill_color
#       })
#
#       @book.cell(next_row + index, 10, '',{
#           :border => [[:bottom, 'thin'], [:left, 'thin'], [:right, 'thin']],
#           :fill_color => fill_color
#       })
#
#     end
#   # ++ Основное тело
#
#   @book.save
# end
