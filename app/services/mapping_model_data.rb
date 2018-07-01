class MappingModelData
  include ApplicationHelper
  attr_accessor :model_data, :modal_query, :check_element

  def initialize(model_data, modal_query = nil, check_element = nil)
    @model_data = model_data
    @modal_query = modal_query if modal_query.present?
    @check_element = check_element if check_element.present?
  end

  def order_manufacturing
    model_data.map do |model_data_i|
      {
          DT_RowId:          model_data_i.id,
          date:              model_data_i.date,
          number:            model_data_i.number,
          counterparty_name: model_data_i.counterparty.name,
          invoice:           model_data_i.invoice,
      }
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
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            check_box_helper({value: model_data_i.id, name: 'item', field_name: '[item_details][id][]', class_name: 'datatable-checkbox'}),
                # model_data_i.id, 'item', '[item_details][id][]','datatable-checkbox'),
            #radio_helper(model_data_i.id, 'counterparty', '[id]','datatable-radio', 'data-dismiss="modal"'),
            model_data_i.name,
            model_data_i.unit,
            #model_data_i.item_type,
            #Float(model_data_i.price),
            #model_data_i.weight.present? ? Float(model_data_i.weight) : 0
        ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:  model_data_i.id,
            name:      model_data_i.name,
            unit:      model_data_i.unit,
            # item_type: model_data_i.item_type,
            price:     0,#Float(model_data_i.price),
            weight:    0#model_data_i.weight.present? ? Float(model_data_i.weight) : 0
        }
      end
    end
  end

  def job
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            check_box_helper({value: model_data_i.id, name: 'job', field_name:'[job_details][id][]', class_name: 'datatable-checkbox'}),
                # model_data_i.id, 'job', '[job_details][id][]','datatable-checkbox'),
            model_data_i.name,
            model_data_i.name_for_print,
            Float(model_data_i.price),
            model_data_i.time,
        ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:         model_data_i.id,
            name:             model_data_i.name,
            name_for_print:   model_data_i.name_for_print,
            price:            Float(model_data_i.price),
            time:             model_data_i.time,
        }
      end
    end
  end

  def worker
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
      [
          model_data_i.first_name,
          model_data_i.last_name,
          model_data_i.middle_name,
          model_data_i.position
      ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:       model_data_i.id,
            first_name:     model_data_i.first_name,
            last_name:      model_data_i.last_name,
            middle_name:    model_data_i.middle_name,
            position:       model_data_i.position,
        }
      end
    end
  end

  def counterparty
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            radio_helper(model_data_i.id, 'counterparty', '[id]','datatable-radio', 'data-dismiss="modal"'),
            model_data_i.name,
            model_data_i.short_name,
            model_data_i.c_type
        ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:  model_data_i.id,
            name: model_data_i.name,
            short_name: model_data_i.short_name,
            c_type: model_data_i.c_type
        }
      end
    end
  end

  def material
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            radio_helper(model_data_i.id, 'material', '[id]','datatable-radio', ''), #data-dismiss="modal"
            model_data_i.name,
            model_data_i.unit
        ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:  model_data_i.id,
            name: model_data_i.name,
            unit: model_data_i.unit
        }
      end
    end
  end

  def semi_finished
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            radio_helper(model_data_i.id, 'semi_finished', '[id]','datatable-radio', ''), #data-dismiss="modal"
            model_data_i.name,
            model_data_i.unit,
            model_data_i.size_l,
            model_data_i.size_a,
            model_data_i.size_b
        ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:  model_data_i.id,
            name: model_data_i.name,
            unit: model_data_i.unit,
            size_l: model_data_i.size_l,
            size_a: model_data_i.size_a,
            size_b: model_data_i.size_b
        }
      end
    end
  end

  def o_m_pre_print
    old_id = nil
    model_data.map.with_index do |model_data_i, index|
      [
          # if old_id.nil?
          #   old_id = model_data_i[0].id
          #   set_value = true
          #   check_box_helper({ value: model_data_i[0].id, field_name: '[o_m_details_pre_print][id][]',
          #             checked: true, data: "data-class = '#{model_data_i[0].class.to_s}' data-index = '#{index}'",
          #             id: "check_#{model_data_i[0].class.to_s}_#{index}"})
          # else
          #   if old_id == model_data_i[0].id
          #     set_value = false
          #     check_box_helper({ value: model_data_i[0].id, field_name: '[o_m_details_pre_print][id][]',
          #                        data: "data-class = '#{model_data_i[0].class.to_s}' data-index = '#{index}'",
          #                        id: "check_#{model_data_i[0].class.to_s}_#{index}"})
          #   else
          #     old_id = model_data_i[0].id
          #     set_value = true
          #     check_box_helper({ value: model_data_i[0].id, field_name: '[o_m_details_pre_print][id][]',
          #                        checked: true, data: "data-class = '#{model_data_i[0].class.to_s}' data-index = '#{index}'",
          #                        id: "check_#{model_data_i[0].class.to_s}_#{index}"})
          #
          #   end
          # end,
          check_box_helper({ value: model_data_i[0].id, field_name: '[o_m_details_pre_print][id][]',
                             data: "data-class = '#{model_data_i[0].class.to_s}' data-index = '#{index}'",
                             id: "check_#{model_data_i[0].class.to_s}_#{index}"}),
          model_data_i[0].name,
          model_data_i[0].is_a?(Item) ? model_data_i[0].unit : '',
          Float(model_data_i[1]),
          # text_helper({value: set_value.present? ? index : '', field_name: '[o_m_details_pre_print][index][]', visible: false,
          #              id: "hidden_#{model_data_i[0].class.to_s}_#{index}"}),
          text_helper({value: '', field_name: '[o_m_details_pre_print][index][]', visible: false,
          id: "hidden_#{model_data_i[0].class.to_s}_#{index}"}),
          text_helper({value: model_data_i[0].class.to_s, field_name: '[o_m_details_pre_print][class][]', visible: false,
                       id: "hidden_class_#{model_data_i[0].class.to_s}_#{index}"})
      ]
    end
  end
end