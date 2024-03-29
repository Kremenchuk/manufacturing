class OrderManufacturingsController < ApplicationController

  # o_m -> order_manufacturing

  before_action :find_o_m, only: [:edit, :update, :destroy, :copy_o_m, :o_m_used_materials, :o_m_used_jobs, :o_m_change_status, :remove_file_from_o_m, :o_m_write_off_materials,
  :o_m_save_write_off_materials, :automatic_print]

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

  def details_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit],
        model: Item,
        search_query: 'UPPER(name) like :search or
                       item_group_id IN (SELECT item_groups.id FROM item_groups WHERE UPPER(item_groups.name) like :search)',
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

  def details_pre_print_datatable
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
    @item_groups = ItemGroup.all
    @o_m = OrderManufacturing.new
    if session[:o_m].present?
      @o_m.attributes = session[:o_m].as_json
      @o_m.number = @o_m.counterparty.short_name + '-'
      @o_m_details = OrderManufacturing.find(session[:o_m]['id']).items if session[:o_m]['id'].present?
      @o_m.id = nil
      @o_m.start_date = nil
      @o_m.finish_date = nil
      @o_m.o_m_status = :no_status
      # session.delete(:o_m)
    end
  end

  def edit
    add_returning_path

    @item_groups = ItemGroup.all
    @o_m_details = @o_m.items
  end

  def update
    @item_groups = ItemGroup.all
    o_m_files_in_o_m = @o_m.o_m_files
    @o_m.attributes = permit_params
    if permit_params[:o_m_files].present?
      o_m_files_in_o_m += permit_params[:o_m_files]
    end
    @o_m.o_m_files = o_m_files_in_o_m
    create_update_action(@o_m, params.permit(:commit)[:commit])
  end

  def destroy
    @o_m.destroy
    flash[:messages] = "'#{@o_m.number}' #{t('all_form.deleted')}"
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
    if @o_m.save and @o_m.o_m_status == :no_status
      @o_m.orders_manual_materials.each do |used_material|
        used_material.material.qty += used_material.qty
        used_material.material.save!
      end
      @o_m.orders_manual_materials.destroy_all
    end
    redirect_to edit_order_manufacturing_path(@o_m.id)
  end


  def automatic_print
    excel_file = OrderManufacturingPrint.new(@o_m, "#{@o_m.number.to_s}" + ".xlsx")

    excel_file.print
    # redirect_to edit_order_manufacturing_path(params[:id])
    send_file excel_file.file_name
  end

  def o_m_used_materials
    @used_materials = Array.new
    if @o_m.materials.present?
      @used_materials << @o_m.orders_manual_materials
      @used_materials << 0
    else
      @used_materials << @o_m.used_materials
      @used_materials << 1
    end
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

  def o_m_write_off_materials
    @used_materials = Array.new
    @used_materials << @o_m.used_materials
    @used_materials << 1
  end

  def o_m_save_write_off_materials
    if permit_write_off_materials.present?
      if @o_m.orders_manual_materials.present?
        @o_m.orders_manual_materials.destroy
      end
      permit_write_off_materials[:id].each_with_index do |material_id, index|
        material = Material.find_by_id(material_id)
        o_m_material = OrdersManualMaterial.new
        o_m_material.material = material
        o_m_material.order_manufacturing = @o_m
        o_m_material.qty = permit_write_off_materials[:qty][index].to_f
        o_m_material.save!
        material.qty -= permit_write_off_materials[:qty][index].to_f
        material.save!
      end
      @o_m.o_m_status = params[:o_m_status]
      @o_m.save!
    end
    redirect_to edit_order_manufacturing_path(@o_m.id) and return
  end


  private

  def create_update_action(o_m, commit)
      o_m.counterparty = Counterparty.find_by(name: params[:order_manufacturing][:counterparty])
      o_m.user = current_user
      o_m.finish_date = permit_params[:finish_date].to_date
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
        redirect_to new_order_manufacturing_path(copy: true) and return
        return
      end
      if commit == t('all_form.save_out')
        redirect_to root_path(active_tab: 'order_manufacturing') and return
      else
        redirect_to edit_order_manufacturing_path(o_m.id) and return
      end
  end

  def permit_params
    params.require(:order_manufacturing).permit(:start_date, :finish_date, :number, :invoice, :total_price, :con_pay,:note, :extra_charge, :indirect_costs, :payroll_taxes, {o_m_files: []}) #counterparty.name
  end

  def permit_type_id_qty
    params.require('details').permit(id: [], qty: [])
  end

  def permit_write_off_materials
    params.require('materials').permit(id: [], qty: [])
  end

  def find_o_m
    @o_m = OrderManufacturing.find(params[:id])
  end

end
