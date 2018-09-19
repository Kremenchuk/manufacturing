class OrderManufacturingPrePrint

  def initialize(o_m_id)
    @o_m = OrderManufacturing.find(o_m_id)
  end

  def prepare_print(sort_auto = false)
    # o_m_items = [id, Class, qty, print?]
    o_m_items = Array.new
    @o_m.order_manufacturings_details.each do |stillage|
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
      find_db_element(array_down_job(sort_array(o_m_items)))
    else
      find_db_element(array_down_job(o_m_items))
    end
  end

  private

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
  def sort_array(array_to_sort)
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

  def find_db_element(a)
    o_m_details = Array.new
    a.each do |elem|
      o_m_details << [elem[1].constantize.find(elem[0]), elem[2]]
    end
    return o_m_details
  end

end
