class MaterialsController < ApplicationController

  before_action :find_material, only: [:edit, :update, :destroy, :copy_material, :item_inclusions]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit],
        model: Material,
        search_query: 'UPPER(name) like :search'
    }
    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def material_details_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit],
        model: Material,
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

  # def add_material_detail
  #   params.require('material').permit('id')
  #   @semi_finished_details = Material.find(params['material']['id'])
  # end

  def new
    @material = Material.new
    if session[:material].present?
      @material.attributes = session[:material].as_json
      session.delete(:material)
    end
  end

  def edit
    add_returning_path
  end

  def create
    Material.create(permit_params)
    redirect_to root_path(active_tab: 'material')
  end

  def update
    @material.update!(permit_params)
    redirect_to root_path(active_tab: 'material')
  end

  def destroy
    if find_item_inclusions(@material).present?
      flash[:messages] = t('material.cant_delete')
      flash[:class] = 'flash-error'
      redirect_to edit_material_path(@material)
    else
      @material.destroy
      flash[:messages] = "'#{@material.name}' #{t('all_form.deleted')}"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'material')
    end
  end

  def copy_material
    # @material.name = 'Новый материал'
    @material.id = nil
    session[:material] = @material.attributes
    redirect_to new_material_path
  end

  def item_inclusions
    @item_inclusions = find_item_inclusions(@material)
    render 'layouts/item_inclusions'
  end

  private

  def permit_params
    attributes = params.require(:material).permit(:id, :name, :manual_write_off, :round_one, :unit, :weight, :area, :volume, :price, :size_a, :size_b, :note)
    attributes[:price] = attributes[:price].gsub(',', '.')
    return attributes
  end

  def find_material
    @material = Material.find(params[:id])
  end
end
