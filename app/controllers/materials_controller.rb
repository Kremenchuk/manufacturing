class MaterialsController < ApplicationController

  before_action :find_material, only: [:edit, :update, :destroy, :copy_material]

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
    if (SemiFinishedDetail.where(semi_finished_detailable_type: 'Material', semi_finished_detailable_id: @material.id)).present?
      flash[:messages] = "'#{@material.name}' невозможно удалить! Данный материал задействован"
      flash[:class] = 'flash-error'
      redirect_to edit_material_path(@material.id)
    else
      @material.destroy!
      flash[:messages] = "'#{@material.name}' удалено"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'material')
    end
  end

  def copy_material
    @material.name = 'Новый материал'
    @material.id = nil
    session[:material] = @material.attributes
    redirect_to new_material_path
  end

  private

  def permit_params
    attributes = params.require(:material).permit(:id, :name, :unit, :price, :size_a, :size_b,:note)
    attributes[:price] = attributes[:price].gsub(',', '.')
    return attributes
  end

  def find_material
    @material = Material.find(params[:id])
  end
end
