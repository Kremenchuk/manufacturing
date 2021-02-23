class PayrollsController < ApplicationController

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[number date worker.fio],
        model: Payroll,
        search_query: 'date like :search or UPPER(number) like :search or UPPER(worker.fio) like :search'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end


  def new
    @payroll = Payroll.new
  end

  def edit
    a=2
  end
end
