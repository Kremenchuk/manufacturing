class PurchaseInvoicesController < ApplicationController

  before_action :find_p_i, only: [:edit, :update, :destroy, :material_to_warehouse, :material_from_warehouse]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[number date counterparty.name],
        model: PurchaseInvoice,
        search_query: 'UPPER(number) like :search or date like :search or
                       counterparty_id IN (SELECT counterparties.id FROM counterparties WHERE UPPER(counterparties.name) like :search)',
    }
    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def p_i_details_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit qty],
        model: PurchaseInvoice,
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


  def p_i_counterparty_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name short_name c_type],
        model: Counterparty,
        search_query: 'UPPER(name) like :search',
        modal_query: 'nil'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end


  def p_i_material_details_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit],
        model: Material,
        search_query: 'UPPER(name) like :search',
        modal_query: 'select'
    }
    if params[:ids].present?
      data_hash[:modal_query] = "id NOT IN (#{params[:ids].join(',')})"
    end

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end


  def new
    @p_i = PurchaseInvoice.new
  end

  def edit
    @p_i_details = @p_i.purchase_invoices_details
  end

  def update
    @p_i.attributes = permit_params
    create_update_action(@p_i, params.permit(:commit)[:commit])
  end

  def create
    @p_i = PurchaseInvoice.new(permit_params)
    create_update_action(@p_i, params.permit(:commit)[:commit])
  end

  def destroy
    if @p_i.destroy!
      flash[:messages] = "'#{@p_i.number}' удалено"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'p_i')
    else
      flash[:messages] = "'#{@p_i.number}' не удалено #{@p_i.errors}"
      flash[:class] = 'flash-error'
    end
  end

  def add_counterparty_p_i
    @counterparty = Counterparty.find(params[:counterparty][:id])
  end


  def material_to_warehouse
    @p_i.purchase_invoices_details.each do |p_i_detail|
      p_i_detail.material.qty = p_i_detail.material.qty + p_i_detail.qty
      p_i_detail.material.price = p_i_detail.price
      p_i_detail.material.save!
    end
    @p_i.p_i_status = 1
    @p_i.save!
    redirect_to edit_purchase_invoice_path(@p_i.id)
  end


  def material_from_warehouse
    @p_i.purchase_invoices_details.each do |p_i_detail|
      p_i_detail.material.qty = p_i_detail.material.qty - p_i_detail.qty
      p_i_detail.material.price = p_i_detail.price
      p_i_detail.material.save!
    end
    @p_i.p_i_status = 0
    @p_i.save!
    redirect_to edit_purchase_invoice_path(@p_i.id)
  end


  def add_p_i_detail
    params.require('material').require('material_details').permit('id': [])
    @p_i_details = Material.find(params['material']['material_details']['id'])
  end

  private

  def create_update_action(p_i, commit)
    p_i.counterparty = Counterparty.find_by(name: params[:purchase_invoice][:counterparty])
    begin
      if p_i.save
        p_i.purchase_invoices_details.each do |purchase_invoices_detail|
          purchase_invoices_detail.destroy!
        end
        if permit_details_params.present?
          permit_details_params[:id].each_with_index do |material_id, index|
            PurchaseInvoicesDetail.find_or_initialize_by(purchase_invoice: p_i, material_id: material_id).tap do |f|
              f.qty = permit_details_params[:qty][index]
              f.price = permit_details_params[:price][index]
              f.save!
            end
          end
        end
      else
        flash[:messages] = "Error: #{p_i.errors.to_json}"
        flash[:class] = 'flash-error'
        flash[:class_element] = 'error-class'
        redirect_to new_purchase_invoice_path
        return
      end

    rescue => e
      flash[:messages] = "'#{p_i.number}' наименование не уникально. Error: #{e}"
      flash[:class] = 'flash-error'
      flash[:class_element] = 'error-class'
      redirect_to new_purchase_invoice_path
      return
    end
    if commit == 'Сохранить и выйти'
      redirect_to root_path(active_tab: 'p_i')
      return
    else
      redirect_to edit_purchase_invoice_path(p_i.id)
      return
    end
  end

  def permit_params
    params.require(:purchase_invoice).permit(:number, :date, :total_price, :we_pay)
    # :area, :weight, :volume,
  end

  def permit_details_params
    params.require('details').permit(id: [], qty: [], price: [])
  end

  def find_p_i
    @p_i = PurchaseInvoice.find(params[:id])
  end



end
