class ItemsController < ApplicationController

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

  def new
    @item = Item.new
  end

  def edit

  end

  def create
    Item.create(permit_params)
    redirect_to root_path(active_tab: 'job')
  end

  private

  def permit_params
    params.require(:item).permit(:name, :unit, :item_type, :area, :price, :volume, :weight)
  end


end
