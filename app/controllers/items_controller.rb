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
end
