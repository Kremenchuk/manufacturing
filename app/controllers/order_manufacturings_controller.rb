class OrderManufacturingsController < ApplicationController

  # o_m -> order_manufacturing

  before_action :find_o_m, only: [:edit, :update, :destroy, :copy_o_m]

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
        sort_column: %w[name unit item_type price weight],
        model: Item,
        search_query: 'UPPER(name) like :search',
        modal_query: 'item_type != 1'
    }
    if params[:ids].present?
      data_hash[:modal_query] = "item_type != 1 AND id NOT IN (#{params[:ids].join(',')})"
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
    create_update_action(@o_m)
  end

  def destroy
    @o_m.destroy!
    flash[:messages] = "'#{@o_m.number}' удалено"
    flash[:class] = 'flash-success'
    redirect_to root_path(active_tab: 'order_manufacturing')
  end

  def create
    create_update_action(OrderManufacturing.new(permit_params))
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

    redirect_to root_path(active_tab: 'order_manufacturing')
  end

  private

  def create_update_action(o_m)
      o_m.counterparty = Counterparty.find_by(name: params[:order_manufacturing][:counterparty])
      if o_m.save
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
      redirect_to root_path(active_tab: 'order_manufacturing')
  end

  def permit_params
    params.require(:order_manufacturing).permit(:date, :number, :invoice, :note) #counterparty.name
  end

  def permit_type_id_qty
    params.require('details').permit(id: [], qty: [])
  end

  def find_o_m
    @o_m = OrderManufacturing.find(params[:id])
  end

end
