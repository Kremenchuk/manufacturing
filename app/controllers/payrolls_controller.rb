class PayrollsController < ApplicationController
  layout false

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[date worker],
        model: Payroll,
        search_query: 'date like :search or worker like :search'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end
end
