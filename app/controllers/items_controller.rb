class ItemsController < ApplicationController


  before_action :find_item, only: [:edit, :update, :destroy, :copy_item, :remove_file_from_item]

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

  def item_item_group_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name range],
        model: ItemGroup,
        search_query: 'UPPER(name) like :search',
        modal_query: 'nil'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end

  end

  def item_material_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit],
        model: Material,
        search_query: 'UPPER(name) like :search',
        modal_query: 'nil'
    }
    # if params[:ids].present?
    #   data_hash[:modal_query] = "id NOT IN (#{params[:ids].join(',')})"
    # end

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def add_item_group
    @item_group = ItemGroup.find(params[:item_group][:id])
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
      find_item_details(session[:item_details])

      session.delete(:item)
      session.delete(:item_details)
    end
  end

  def edit
    find_item_details(@item.details)
  end

  def update
    item_files_in_item = @item.item_files
    @item.attributes = permit_params
    if permit_params[:item_files].present?
      item_files_in_item += permit_params[:item_files]
    end
    @item.item_files = item_files_in_item
    create_update_action(@item, params.permit(:commit)[:commit])
  end

  def create
    item = Item.new(permit_params)
    create_update_action(item, params.permit(:commit)[:commit])
  end

  def destroy
    if @item.destroy!
      flash[:messages] = "'#{@item.name}' удалено"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'item')
    else
      flash[:messages] = "'#{@item.name}' не удалено #{@item.errors}"
      flash[:class] = 'flash-error'
    end
  end

  def copy_item
    @item.name = 'Новая продукция'
    @item.id = nil
    session[:item] = @item.attributes
    session[:item_details] = @item.details
    redirect_to new_item_path(item_type: params[:item_type])
  end


  def remove_file_from_item
    remain_images = @item.item_files
    deleted_image = remain_images.delete_at(params[:file_index].to_i)
    begin
      File.delete(deleted_image.path)
    rescue Errno::ENOENT => e
      flash[:messages] = "Файл не удален. Error: #{e}"
      flash[:class] = 'flash-error'
      flash[:class_element] = 'error-class'
      session[:item] = @item
      exit -1
    end
    @item.item_files = remain_images
    @item.save!

    redirect_to edit_item_path(@item)
  end

  private

  def create_update_action(item, commit)
    begin
      item.item_group = ItemGroup.find_by(name: params[:item][:item_group])
      details = Array.new
      if item.present? && params['details'].present?
        param_details = permit_type_id_qty
        param_details[:id].each_with_index do |el, index|
          details_el = Array.new
          details_el << el.to_i
          details_el << param_details[:details_type][index]
          details_el << param_details[:qty][index].to_f
          if param_details[:print].present?
            details_el << param_details[:print].include?(el) ? true : false
          else
            details_el << false
          end
          details << details_el
        end
      end
      item.details = details
      item.save!
    rescue => e
      flash[:messages] = "'#{item.name}' наименование не уникально. Error: #{e}"
      flash[:class] = 'flash-error'
      flash[:class_element] = 'error-class'
      session[:item] = item
      redirect_to new_item_path(copy: true)
    end
    if commit == 'Сохранить и выйти'
      redirect_to root_path(active_tab: 'item')
    else
      redirect_to edit_item_path(item.id)
    end
  end

  def find_item_details(item_details = nil)
    @item_details = Array.new
    item_details.each do |el|
      begin
        detail = Array.new
        detail << el[1].constantize.find(el[0])
        detail << el[2]
        detail << el[3]
        @item_details << detail
      rescue => e
        next
      end
    end
  end

  def permit_params
    params.require(:item).permit(:name, :unit, :size_l, :size_a, :size_b, :area, :volume, {item_files: []})
    # :area, :weight, :volume,
  end

  def permit_type_id_qty
    params.require('details').permit(details_type: [], id: [], qty: [], print: [])
  end

  def find_item
    @item = Item.find(params[:id])
  end

end
