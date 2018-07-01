class OrderManufacturingsController < ApplicationController

  # o_m -> order_manufacturing

  before_action :find_o_m, only: [:edit, :update, :destroy, :copy_o_m, :o_m_pre_print]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[date number counterparty.name invoice],
        model: OrderManufacturing,
        search_query: 'date like :search or UPPER(number) like :search or UPPER(invoice) like :search or counterparty_id IN (SELECT counterparties.id FROM counterparties WHERE UPPER(counterparties.name) like :search)',
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def o_m_details_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit],
        model: Item,
        search_query: 'UPPER(name) like :search',
        modal_query: 'nil'
    }
    if params[:ids].present?
      data_hash[:modal_query] = "id NOT IN (#{params[:ids].join(',')})"
    end

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def o_m_counterparty_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name short_name c_type],
        model: Counterparty,
        search_query: 'UPPER(name) like :search',
        modal_query: 'c_type != 1'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def o_m_details_pre_print_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit qty],
        model: 'o_m_pre_print',
        search_query: 'nil',
        modal_query: 'nil'
    }
    as = DatatableClass.new(data_hash).with_out_model(o_m_pre_print(params[:id]))
    respond_to do |format|
      format.html
      format.json { render json: as }
    end
  end

  def new
    @o_m = OrderManufacturing.new
    if session[:o_m].present?
      @o_m.attributes = session[:o_m].as_json
      @o_m.number = @o_m.counterparty.short_name + '-'
      @o_m_details = OrderManufacturing.find(session[:o_m]['id']).items if session[:o_m]['id'].present?
      @o_m.id = nil
      @o_m.date = nil
      session.delete(:o_m)
    end
  end

  def edit
    @o_m_details = @o_m.items
  end

  def update
    @o_m.attributes = permit_params
    create_update_action(@o_m, params.permit(:commit)[:commit])
  end

  def destroy
    @o_m.order_manufacturings_details.each do |o_m_detail|
      o_m_detail.destroy!
    end
    @o_m.destroy!
    flash[:messages] = "'#{@o_m.number}' удалено"
    flash[:class] = 'flash-success'
    redirect_to root_path(active_tab: 'order_manufacturing')
  end

  def create
    create_update_action(OrderManufacturing.new(permit_params), params.permit(:commit)[:commit])
  end

  def copy_o_m
    session[:o_m] = @o_m.attributes
    redirect_to new_order_manufacturing_path
  end

  def add_o_m_detail
    params.require('item').require('item_details').permit('id': [])
    @o_m_details = Item.find(params['item']['item_details']['id'])
  end

  def add_counterparty
    @counterparty = Counterparty.find(params[:counterparty][:id])
  end



  def o_m_print
    print_array = Array.new
    print_hash = permit_pre_print
    pre_print_array = o_m_pre_print(params[:id])
    print_index = 0
    print_hash['index'].each_with_index do |i, index|
      if i.present?
        if index == 0
          print_array << pre_print_array[index]
          next
        end
        if pre_print_array[index][0].id == pre_print_array[index - 1][0].id and pre_print_array[index][0].class == pre_print_array[index - 1][0].class
          print_array[print_index][1] = print_array[print_index][1] + pre_print_array[index][1]
        else
          print_array << pre_print_array[index]
          print_index +=1
        end
      else
        print_array << pre_print_array[index]
        print_index +=1
        next
      end

    end

    excel_file = OrderManufacturingPrint.new(params[:id])
    @print_details = excel_file.prepare_print
    # redirect_to edit_order_manufacturing_path(params[:id])
    respond_to do |format|
      format.html
      format.js
    end
    # sort_a = Array.new
    # if a.is_a? Array
    #   a.each_with_index do |elem, index|
    #     sort_a << elem
    #     a.each_with_index do |elem2, index2|
    #       if index2 <= index
    #         next
    #       end
    #       if elem[0] == elem2[0] and elem[1] == elem2[1]
    #         sort_a << elem2
    #         a.delete_at(index2)
    #       end
    #     end
    #   end
    # end
    # return sort_a



  end

  private

  def o_m_pre_print(id)
    OrderManufacturingPrePrint.new(id).prepare_print
  end

  def create_update_action(o_m, commit)
      o_m.counterparty = Counterparty.find_by(name: params[:order_manufacturing][:counterparty])
      if o_m.save
        o_m.order_manufacturings_details.each do |order_manufacturings_detail|
          order_manufacturings_detail.destroy!
        end
        if permit_type_id_qty.present?
          permit_type_id_qty[:id].each_with_index do |item_id, index|
            OrderManufacturingsDetail.find_or_initialize_by(order_manufacturing: o_m, item_id: item_id).tap do |f|
              f.qty = permit_type_id_qty[:qty][index]
              f.save!
            end
          end
        end
      else
        session[:o_m] = o_m.attributes
        flash[:messages] = "Error: #{o_m.errors.to_json}"
        flash[:class] = 'flash-error'
        flash[:class_element] = 'error-class'
        session[:o_m] = o_m
        redirect_to new_order_manufacturing_path(copy: true)
        return
      end
      if commit == 'Сохранить и выйти'
        redirect_to root_path(active_tab: 'order_manufacturing')
      else
        redirect_to edit_order_manufacturing_path(o_m.id)
      end
  end

  def permit_params
    params.require(:order_manufacturing).permit(:date, :number, :invoice, :note) #counterparty.name
  end

  def permit_type_id_qty
    params.require('details').permit(id: [], qty: [])
  end

  def permit_pre_print
    params.require('o_m_details_pre_print').permit(id: [], index: [], class: [])
  end

  def find_o_m
    @o_m = OrderManufacturing.find(params[:id])
  end

end
