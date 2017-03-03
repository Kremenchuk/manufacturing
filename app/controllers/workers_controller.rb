class WorkersController < ApplicationController

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[first_name last_name middle_name position],
        model: Worker,
        search_query: 'UPPER(first_name) like :search or UPPER(middle_name) like :search or UPPER(last_name) like :search or UPPER(position) like :search'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end
end
