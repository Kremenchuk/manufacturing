class OrderManufacturingsController < ApplicationController
  layout false

  def index
    # SELECT c.id FROM counterparties as c WHERE c.name like :search
    data_hash = {
        view_context: view_context,
        sort_column: %w[date number counterparty.name invoice],
        model: OrderManufacturing,
        search_query: 'date like :search or number like :search or counterparties.id IN :join_table_var or invoice like :search',
        join_table: 'counterparties'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end
end
