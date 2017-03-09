class MappingModelData
  attr_accessor :model_data, :modal_query

  def initialize(model_data, modal_query = nil)
    @model_data = model_data
    @modal_query = modal_query if modal_query.present?
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
    if modal_query.present?
      model_data.where(modal_query).map do |model_data_i|
        [
            select_controller_helper(model_data_i.id, model_data_i),
            model_data_i.name,
            model_data_i.unit,
            model_data_i.item_type,
            model_data_i.price,
            model_data_i.weight,
        ]
      end
    else
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