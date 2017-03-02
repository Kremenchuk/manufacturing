class PayrollsController < ApplicationController

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[date worker],
        model: Payroll,
        search_query: 'date like :search or worker_id IN (SELECT workers.id FROM workers WHERE UPPER(workers.first_name) like :search or UPPER(workers.middle_name) like :search or UPPER(workers.last_name) like :search)'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end
end
