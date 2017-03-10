class ItemsController < ApplicationController


  before_action :permit_params, only: [:create, :update]
  before_action :find_item, only: [:show, :edit]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit item_type price weight],
        model: Item,
        search_query: 'UPPER(name) like :search'
    }
    if params[:modal].present?
      data_hash[:search_query] = 'UPPER(name) like :search AND item_type != 0'
      data_hash[:modal_query] = 'item_type != 0'
    end

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def new
    @item = Item.new
  end

  def show

  end

  def edit
    @item = Item.new
    @item_details = @item.item_details
  end

  def update

  end

  def create
    Item.create(permit_params)
    redirect_to root_path(active_tab: 'job')
  end

  def add_item_detail
    params.require('item').require('item_details').permit('id': [])
    @item_details = Item.find(params['item']['item_details']['id'])
    # respond_to do |format|
    #   format.html {redirect_to new_item_path}
    #   format.js {}
    # end
    # redirect_to new_item_path
  end

  private

  def permit_params
    params.require(:item).permit(:name, :unit, :item_type, :area, :price, :volume, :weight)
  end

  def find_item
    @item = Item.find(params[:id])
  end

end
