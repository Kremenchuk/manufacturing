class OrderManufacturingsController < ApplicationController

  # o_m -> order_manufacturing

  before_action :find_o_m, only: [:edit, :update, :destroy, :copy_o_m, :o_m_pre_print, :o_m_used_materials, :o_m_used_jobs, :o_m_change_status, :remove_file_from_o_m]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[start_date finish_date number counterparty.name invoice o_m_status],
        model: OrderManufacturing,
        search_query: 'start_date like :search or finish_date like :search or UPPER(number) like :search or UPPER(invoice) like :search or
                       counterparty_id IN (SELECT counterparties.id FROM counterparties WHERE UPPER(counterparties.name) like :search)',
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
      @o_m.start_date = nil
      @o_m.finish_date = nil
      @o_m.o_m_status = 0
      session.delete(:o_m)
    end
  end

  def edit
    @o_m_details = @o_m.items
  end

  def update
    o_m_files_in_o_m = @o_m.o_m_files
    @o_m.attributes = permit_params
    if permit_params[:o_m_files].present?
      o_m_files_in_o_m += permit_params[:o_m_files]
    end
    @o_m.o_m_files = o_m_files_in_o_m
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

  def o_m_change_status
    @o_m.o_m_status = params[:o_m_status]
    if @o_m.save and @o_m.o_m_status == 1
      @o_m.used_materials.each do |used_material|
        used_material[0].qty -= used_material[1]
        used_material[0].save!
      end
    end
    if @o_m.save and @o_m.o_m_status == 0
      @o_m.used_materials.each do |used_material|
        used_material[0].qty += used_material[1]
        used_material[0].save!
      end
    end
    redirect_to edit_order_manufacturing_path(@o_m.id)
  end

  # def o_m_hand_print
  #   print_array = Array.new
  #   print_string = params[:item_arr_to_print]
  #
  #   i = 0
  #   print_array_cycle = Array.new
  #   print_string.split(',').each do |el|
  #     print_array_cycle << el
  #     i = i + 1
  #     if i == 3
  #       print_array << print_array_cycle
  #       print_array_cycle = []
  #       i = 0
  #     end
  #
  #   end
  #   excel_file = OrderManufacturingPrint.new(params[:id])
  #   excel_file.print(excel_file.find_db_element(print_array))
  #   # redirect_to edit_order_manufacturing_path(params[:id])
  #   send_file excel_file.file_name
  # end

  def o_m_automatic_print
    excel_file = OrderManufacturingPrint.new(params[:id])
    excel_file.print
    # redirect_to edit_order_manufacturing_path(params[:id])
    send_file excel_file.file_name
  end

  def o_m_used_materials
    @used_materials = @o_m.used_materials
  end

  def o_m_used_jobs
    @used_jobs = @o_m.used_jobs
  end

  def remove_file_from_o_m
    remain_images = @o_m.o_m_files
    deleted_image = remain_images.delete_at(params[:file_index].to_i)
    begin
      File.delete(deleted_image.path)
    rescue Errno::ENOENT => e
      flash[:messages] = "Файл не удален. Error: #{e}"
      flash[:class] = 'flash-error'
      flash[:class_element] = 'error-class'
      session[:o_m] = @o_m
      exit -1
    end
    @o_m.o_m_files = remain_images
    @o_m.save!

    redirect_to edit_order_manufacturing_path(@o_m)
  end

  private

  # def o_m_pre_print(id)
  #   OrderManufacturingPrint.new(id).prepare_print
  # end

  def create_update_action(o_m, commit)
      o_m.counterparty = Counterparty.find_by(name: params[:order_manufacturing][:counterparty])
      o_m.user = current_user
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
    params.require(:order_manufacturing).permit(:start_date, :finish_date, :number, :invoice, :total_price, :con_pay,:note, {o_m_files: []}) #counterparty.name
  end

  def permit_type_id_qty
    params.require('details').permit(id: [], qty: [])
  end

  def find_o_m
    @o_m = OrderManufacturing.find(params[:id])
  end

end
