class ItemsController < ApplicationController


  before_action :find_item, only: [:edit, :update, :destroy, :copy_item]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit item_type price weight],
        model: Item,
        search_query: 'UPPER(name) like :search'
    }
    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def item_details_datatable
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

  def add_item_detail
    @item_details = Array.new
    params.permit('entity')
    case params[:entity]
      when 'item'
        params.require('item').permit('id')
        Item.find(params['item']['item_details']['id']).each do |item|
          detail = Array.new
          detail << item
          detail << 0.0
          @item_details << detail
        end
      when 'job'
        params.require('job').require('job_details').permit('id': [])
        Job.find(params['job']['job_details']['id']).each do |job|
          detail = Array.new
          detail << job
          detail << 0.0
          @item_details << detail
        end
      when 'material'
        params.require('material').permit('id')
        detail = Array.new
        detail << Material.find(params['material']['id'])
        detail << 0.0
        @item_details << detail
    end
  end

  def new
    @item = Item.new
    if session[:item].present?
      @item.attributes = session[:item].as_json
      session.delete(:item)
    end
  end

  def edit
    @item_details = Array.new
    @item.details.each do |el|
      detail = Array.new
      detail << el[1].constantize.find(el[0])
      detail << el[2]
      @item_details << detail
    end
  end

  def update
    @item.attributes = permit_params
    create_update_action(@item)
  end

  def create
    item = Item.new(permit_params)
    create_update_action(item)
  end

  def destroy
    @item.destroy!
    flash[:messages] = "'#{@item.name}' удалено"
    flash[:class] = 'flash-success'
    redirect_to root_path(active_tab: 'item')
  end

  def copy_item
    @item.name = 'Новая продукция'
    @item.id = nil
    session[:item] = @item.attributes
    redirect_to new_item_path(item_type: params[:item_type])
  end


  private

  def create_update_action(item)
    begin
      details = Array.new
      if item.present? && params['details'].present?
        param_details = permit_type_id_qty
        param_details[:id].each_with_index do |el, index|
          details_el = Array.new
          details_el << el.to_i
          details_el << param_details[:details_type][index]
          details_el << param_details[:qty][index].to_f
          details << details_el
        end
      end
      item.details = details
      item.save!
      redirect_to root_path(active_tab: 'item')
    rescue => e
      flash[:messages] = "'#{item.name}' наименование не уникально. Error: #{e}"
      flash[:class] = 'flash-error'
      flash[:class_element] = 'error-class'
      session[:item] = item
      redirect_to new_item_path(copy: true)
    end
  end

  def find_item_details(item_id)
    @item = Item.find(item_id)
    @item_details = @item.item_details_list
  end

  def permit_params
    params.require(:item).permit(:name, :unit, :size_l, :size_a, :size_b)
    # :area, :weight, :volume,
  end

  def permit_type_id_qty
    params.require('details').permit(details_type: [], id: [], qty: [])
  end

  def find_item
    @item = Item.find(params[:id])
  end

end
