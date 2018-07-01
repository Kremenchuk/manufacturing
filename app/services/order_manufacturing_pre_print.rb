class OrderManufacturingPrePrint

  def initialize(o_m_id)
    @o_m = OrderManufacturing.find(o_m_id)
  end

  def prepare_print
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
    return find_db_element(sort_array(o_m_items))

  end

  private

  def sort_array(a)
    sort_a = Array.new
    if a.is_a? Array
      a.each_with_index do |elem, index|
        sort_a << elem
        a.each_with_index do |elem2, index2|
          if index2 <= index
            next
          end
          if elem[0] == elem2[0] and elem[1] == elem2[1]
            sort_a << elem2
            a.delete_at(index2)
          end
        end
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
