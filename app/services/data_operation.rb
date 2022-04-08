class DataOperation
  def self.marge_unit(unit_array)
    unit_array.compact!
    if unit_array.present?
      if unit_array[0].is_a? Array
        unit_array = unit_array.flatten(1)
      end
    end
    sum_unit = Array.new
    for i in 0..(unit_array.size - 1)
      if unit_array[i].nil?
        next
      else
        unit_qty = unit_array[i][:qty]
      end
      for j in (i+1)..(unit_array.size - 1)
        if unit_array[i].present? and unit_array[j].present?
          if unit_array[i][:entity].id == unit_array[j][:entity].id
            unit_qty = unit_qty + unit_array[j][:qty]
            unit_array[j] = nil
          end
        end
      end
      sum_unit << [unit_array[i][:entity], unit_qty]
    end

    return sum_unit
  end
end
