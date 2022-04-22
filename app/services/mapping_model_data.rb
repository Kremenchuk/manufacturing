class MappingModelData
  include ApplicationHelper
  attr_accessor :model_data, :modal_query, :check_element, :data_hash

  def initialize(model_data, data_hash, modal_query = nil, check_element = nil)
    @data_hash = data_hash
    @model_data = model_data
    @modal_query = modal_query if modal_query.present?
    @check_element = check_element if check_element.present?
  end

  def order_manufacturing
    model_data.map do |model_data_i|
      {
          DT_RowId:          model_data_i.id,
          start_date:        model_data_i.start_date,
          finish_date:       model_data_i.finish_date.to_date.strftime('%d.%m.%Y'),
          number:            model_data_i.number,
          counterparty_name: model_data_i.counterparty.nil? ? 'ОШИБКА КОНТРАГЕНТА': model_data_i.counterparty.name,
          invoice:           model_data_i.invoice,
          o_m_status:        model_data_i.o_m_status
      }
    end
  end

  def payroll
    model_data.map do |model_data_i|
      {
          DT_RowId:   model_data_i.id,
          number:     model_data_i.number,
          date:       model_data_i.date.to_date.strftime('%d.%m.%Y'),
          worker_fio: model_data_i.worker.nil? ? 'ОШИБКА РАБОЧЕГО': model_data_i.worker.fio
      }
    end
  end


  def purchase_invoice
    model_data.map do |model_data_i|
      {
          DT_RowId:           model_data_i.id,
          counterparty_name:  model_data_i.counterparty.nil? ? 'ОШИБКА КОНТРАГЕНТА': model_data_i.counterparty.name,
          number:             model_data_i.number,
          date:               model_data_i.date,
          p_i_status:         model_data_i.p_i_status
      }
    end
  end


  def item
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            check_box_helper({ value: model_data_i.id, name: 'item', field_name: '[item_details][id][]',
                              class_name: 'datatable-checkbox', id: model_data_i.id }),
                # model_data_i.id, 'item', '[item_details][id][]','datatable-checkbox'),
            #radio_helper(model_data_i.id, 'counterparty', '[id]','datatable-radio', 'data-dismiss="modal"'),
            model_data_i.name,
            model_data_i.unit,
            model_data_i.item_group.name
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
            price:     Float(model_data_i.price),
            weight:    model_data_i.weight.present? ? Float(model_data_i.weight) : 0,
            item_group:    model_data_i.item_group.name
        }
      end
    end
  end

  def job
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            check_box_helper({value: model_data_i.id, name: 'job', field_name:'[job_details][id][]',
                              class_name: 'datatable-checkbox', id: model_data_i.id}),
                # model_data_i.id, 'job', '[job_details][id][]','datatable-checkbox'),
            model_data_i.name,
            model_data_i.name_for_print,
            Float(model_data_i.price),
            model_data_i.time
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
          radio_helper(model_data_i.id, 'worker', '[id]','datatable-radio'),
          model_data_i.fio,
          model_data_i.position
      ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:       model_data_i.id,
            fio:            model_data_i.fio,
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

  def item_group
    if modal_query.present?
      model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
        [
            radio_helper(model_data_i.id, 'item_group', '[id]','datatable-radio', 'data-dismiss="modal"'),
            model_data_i.name,
            model_data_i.range,
        ]
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:  model_data_i.id,
            name: model_data_i.name,
            short_name: model_data_i.range,
        }
      end
    end
  end


  def material
    if modal_query.present?
      if modal_query == 'select'
        model_data.map do |model_data_i|
          [
              check_box_helper({value: model_data_i.id, name: 'material', field_name:'[material_details][id][]',
                                class_name: 'datatable-checkbox', id: model_data_i.id}),
              model_data_i.name,
              model_data_i.unit
          ]

        end
      else
        model_data.where(modal_query != 'nil' ? modal_query : nil).map do |model_data_i|
          [
              radio_helper(model_data_i.id, 'material', '[id]','datatable-radio', ''), #data-dismiss="modal"
              model_data_i.name,
              model_data_i.unit
          ]

        end
      end
    else
      model_data.map do |model_data_i|
        {
            DT_RowId:  model_data_i.id,
            name:      model_data_i.name,
            unit:      model_data_i.unit,
            qty:       model_data_i.qty,
            price:     model_data_i.price
        }
      end
    end
  end

  def o_m_pre_print
    model_data.map.with_index do |model_data_i, index|
      [
          check_box_helper({ class_name: 'o_m_details_pre_print-class',
                             data: "data-id = '#{model_data_i[0].id}' data-class = '#{model_data_i[0].class.to_s}' data-index = '#{index}' data-qty = '#{Float(model_data_i[1])}'",
                             id: "check_#{index}"}),
          model_data_i[0].name,
          model_data_i[0].is_a?(Item) ? model_data_i[0].unit : '',
          Float(model_data_i[1])
      ]
    end
  end

  def o_ms_in_payroll
    # start_date finish_date number counterparty.name invoice o_m_status
    model_data.map.with_index do |model_data_i, index|
      [
        radio_helper(model_data_i.id, 'o_m_in_payroll', '[id]','datatable-radio'),
        # check_box_helper({ class_name: 'o_ms_in_payroll-class',
        #                    data: "data-id = '#{model_data_i.id}' data-class = '#{model_data_i.class.to_s}' data-index = '#{index}' ",
        #                    id: "check_#{index}"}),
        model_data_i.start_date,
        model_data_i.finish_date.to_date.strftime('%d.%m.%Y'),
        model_data_i.number,
        model_data_i.counterparty.name,
        model_data_i.invoice
      ]
    end
  end

  def job_in_payroll
    model_data.map.with_index do |model_data_i, index|
      [
        check_box_helper( { value: "{'o_m_id':'#{@data_hash[:o_m].id}','job_id':'#{model_data_i[:job].id}'}", name: 'job', field_name:'[id][]',
                          class_name: 'datatable-checkbox', id: model_data_i[:job].id }, { o_m_id: @data_hash[:o_m].id } ),
        model_data_i[:job].name,
        Float(model_data_i[:qty_in_o_m].to_f.round(3)),
        Float(model_data_i[:residual_qty].to_f.round(3)),
        model_data_i[:job].price.to_f.round(2),
        model_data_i[:job].time
      ]
    end
  end
end