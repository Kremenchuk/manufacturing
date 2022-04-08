class PayrollsController < ApplicationController

  before_action :find_payroll, only: [:edit, :update, :destroy, :copy_o_m, :o_m_pre_print, :o_m_used_materials, :o_m_used_jobs, :o_m_change_status, :remove_file_from_o_m]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[number date worker.fio],
        model: Payroll,
        search_query: 'UPPER(number) like :search or date like :search or worker_id IN (SELECT workers.id FROM workers WHERE UPPER(workers.fio) like :search)'
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
    add_returning_path
  end


  private

  def find_payroll
    @payroll = Payroll.find(params[:id])
  end
end
