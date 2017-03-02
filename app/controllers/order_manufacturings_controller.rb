class OrderManufacturingsController < ApplicationController

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[date number counterparty.name invoice],
        model: OrderManufacturing,
        search_query: 'date like :search or UPPER(number) like :search or UPPER(invoice) like :search or counterparty_id IN (SELECT counterparties.id FROM counterparties WHERE UPPER(counterparties.name) like :search)',
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end
end
