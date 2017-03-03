class MappingModelData
  attr_accessor :model_data

  def initialize(model_data)
    @model_data = model_data
  end

  def order_manufacturing
    model_data.map do |model_data_i|
      [
          model_data_i.date,
          model_data_i.number,
          model_data_i.counterparty.name,
          model_data_i.invoice,
      ]
    end
  end

  def payroll
    model_data.map do |model_data_i|
      [
          model_data_i.date,
          "#{model_data_i.worker.first_name} #{model_data_i.worker.last_name} #{model_data_i.worker.middle_name}"
      ]
    end
  end

  def item
    model_data.map do |model_data_i|
      [
          model_data_i.name,
          model_data_i.unit,
          model_data_i.item_type,
          model_data_i.price,
          model_data_i.weight,
      ]
    end
  end

  def job
    model_data.map do |model_data_i|
      [
          model_data_i.name,
          model_data_i.price,
          model_data_i.time,
          model_data_i.print.present? ? 'Да' : 'Нет'
      ]
      end
  end

  def worker
    model_data.map do |model_data_i|
      [
          model_data_i.first_name,
          model_data_i.last_name,
          model_data_i.middle_name,
          model_data_i.position
      ]
    end
  end

  def counterparty
    model_data.map do |model_data_i|
      [
          model_data_i.name,
          model_data_i.short_name,
          model_data_i.c_type
      ]
    end
  end
end