class OrderManufacturingsController < ApplicationController
  layout false

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[date number counterparty.name invoice],
        model: OrderManufacturing,
        search_query: 'date like :search or number like :search or
(order_manufacturings.counterparty_id = SELECT c.id FROM counterparties as c WHERE c.name like :search) or
like :search or invoice like :search'.delete("\n")
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end
end
