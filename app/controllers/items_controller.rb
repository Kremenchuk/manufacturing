class ItemsController < ApplicationController
  before_action :find_item, only: [:edit, :update, :destroy, :copy_item, :remove_file_from_item, :item_details_datatable,
                                   :item_inclusions]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit price weight item_group],
        model: Item,
        search_query: 'UPPER(name) like :search or
                       item_group_id IN (SELECT item_groups.id FROM item_groups WHERE UPPER(item_groups.name) like :search)'
    }
    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def item_details_datatable
    ids = (find_item_inclusions(@items) + params[:ids]).join(',')
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit item_group],
        model: Item,
        search_query: 'UPPER(name) like :search or
                       item_group_id IN (SELECT item_groups.id FROM item_groups WHERE UPPER(item_groups.name) like :search)',
        modal_query: 'nil'
    }
    if ids.present?
      data_hash[:modal_query] = "id NOT IN (#{ids})"
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
    # params.permit('entity')
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
    @copyied = false
    if session[:item_id].present?
      @copyied = true
      copied_item = Item.find(session[:item_id])
      @item.attributes = copied_item.attributes
      @item.id = nil
      @item.item_details = copied_item.item_details
      @item_details = @item.item_details

      session.delete(:item_id)
    end
  end

  def edit
    add_returning_path
    @item_details = @item.item_details
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
    if find_item_inclusions(@items).present?
      flash[:messages] = t('items.cant_delete')
      flash[:class] = 'flash-error'
      redirect_to edit_item_path(@item)
    else
      if @item.destroy
        flash[:messages] = "'#{@item.name}' #{t('all_form.deleted')}"
        flash[:class] = 'flash-success'
        redirect_to root_path(active_tab: 'item')
      else
        flash[:messages] = "'#{@item.name}' #{t('all_form.not_deleted')} #{@item.errors}"
        flash[:class] = 'flash-error'
      end
    end
  end

  def copy_item
    session[:item_id] = @item.id
    redirect_to new_item_path
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
      session[:details] = @item.item_details
      exit -1
    end
    @item.item_files = remain_images
    @item.save!

    redirect_to edit_item_path(@item)
  end

  def item_inclusions
    @item_inclusions = find_item_inclusions(@item)
    render 'layouts/item_inclusions'
  end

  private

  def create_update_action(item, commit)
    begin
      ItemDetail.transaction do
        Item.transaction do
          item.item_group = ItemGroup.find_by(name: params[:item][:item_group])
          item.save!
          if params['details'].present?
            item.item_details.destroy_all
            param_details = permit_type_id_qty
            param_details[:id].each_with_index do |el, index|
              ItemDetail.create!(
                item: item,
                detailable: param_details[:details_type][index].constantize.find(el),
                qty: param_details[:qty][index].to_f,
                print_in_o_m: if param_details[:print].present?
                                param_details[:print].include?(el) ? true : false
                              else
                                false
                              end

              )
            end
          end
        end
      end
    rescue => e
      flash[:messages] = "'#{item.name}'. Error: #{e}"
      flash[:class] = 'flash-error'
      flash[:class_element] = 'error-class'
      session[:item] = item
      session[:details] = item.item_details
      redirect_to new_item_path(copy: true) and return
    end
    if commit == t('all_form.save_out')
      redirect_to root_path(active_tab: 'item') and return
    else
      redirect_to edit_item_path(item.id) and return
    end
  end

  def permit_params
    params.require(:item).permit(:name, :unit, :size_l, :size_a, :size_b, :area, :volume, :print_in_collection,  {item_files: []})
    # :area, :weight, :volume,
  end

  def permit_type_id_qty
    params.require('details').permit(details_type: [], id: [], qty: [], print: [])
  end

  def find_item
    @item = Item.find(params[:id])
  end

end
