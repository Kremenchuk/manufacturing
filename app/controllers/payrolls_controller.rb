class PayrollsController < ApplicationController

  before_action :find_payroll, only: [:edit, :update, :destroy, :jobs_datatable]

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

  def workers_datatable
    data_hash = {
      view_context: view_context,
      sort_column: %w[fio position],
      model: Worker,
      modal_query: 'nil',
      search_query: 'UPPER(fio) like :search or UPPER(position) like :search'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def check_o_m_datatable
    data_hash = {
      view_context: view_context,
      sort_column: %w[start_date finish_date number counterparty.name invoice],
      model: 'o_ms_in_payroll',
      modal_query: 'nil',
      search_query: 'start_date like :search or finish_date like :search or UPPER(number) like :search or UPPER(invoice) like :search or
                       counterparty_id IN (SELECT counterparties.id FROM counterparties WHERE UPPER(counterparties.name) like :search)',
      model_data: OrderManufacturing.where(o_m_status: :in_progress)
    }
    response = DatatableClass.new(data_hash).with_out_model

    respond_to do |format|
      format.html
      format.json { render json: response }
    end
  end

  def jobs_datatable
    data_hash = {
      view_context: view_context,
      sort_column: %w[name name_for_print price time],
      model: 'job_in_payroll',
      search_query: '',
      modal_query: 'nil'
    }
    if session[:o_m_payroll_id].present?
      if params[:ids].present?
        data_hash[:modal_query] = "id NOT IN (#{params[:ids].join(',')})"
      end
      o_m = OrderManufacturing.find(session[:o_m_payroll_id])
      data_hash[:o_m] = o_m
      data_hash[:model_data] = o_m.used_jobs
      session.delete(:o_m_payroll_id)
      response = DatatableClass.new(data_hash).with_out_model
    else
      response = DatatableClass.new(data_hash).empty_response
    end

    respond_to do |format|
      format.html
      format.json { render json: response }
    end
  end

  def add_details
    @payroll_details = []
    if permit_details_param[:id].present?
      permit_details_param[:id].each do |value|
        add_to_table = JSON.parse(value.gsub("'",'"'))
        selected_o_m = OrderManufacturing.find(add_to_table["o_m_id"])
        selected_job = Job.find(add_to_table["job_id"])
        @payroll_details << {
          job: selected_job,
          o_m: selected_o_m,
          qty: 0,
          qty_o_m: selected_o_m.used_jobs.select { |job, qty| break qty if job == selected_job },
          sum: 0
        }
      end
    end
  end

  def check_o_m
    session[:o_m_payroll_id] = OrderManufacturing.find(params.require(:o_m_in_payroll).permit(:id)[:id]).id
  end

  def add_worker
    @worker = Worker.find(params.require(:worker).permit(:id)[:id])
  end

  def create
    create_update_action(Payroll.new)
  end

  def new
    @payroll = Payroll.new
  end

  def edit
    add_returning_path
    @payroll_details = @payroll.details.map { |detail| detail_json(detail) }
  end

  def update
    create_update_action(@payroll)
  end

  def destroy
    @payroll.destroy
    flash[:messages] = "'#{@payroll.number}' #{t('all_form.deleted')}"
    flash[:class] = 'flash-success'
    redirect_to root_path(active_tab: 'payroll')
  end

  private

  def create_update_action(payroll)
    PayrollDetail.transaction do
      Payroll.transaction do
        payroll.attributes = permit_params
        payroll.worker = Worker.find_by_fio(params.require(:payroll).permit(:worker)[:worker])
        payroll.date = permit_params[:date].to_date
        payroll.details.destroy_all
        permit_save_details_param[:id].each_with_index do |value, index|
          add_to_table = JSON.parse(value.gsub("'",'"'))
          selected_o_m = OrderManufacturing.find(add_to_table["o_m_id"])
          selected_job = Job.find(add_to_table["job_id"])
          PayrollDetail.create(
            order_manufacturing: selected_o_m,
            job: selected_job,
            payroll: payroll,
            qty: permit_save_details_param[:qty][index],
            sum: Float(selected_job.price * permit_save_details_param[:qty][index].to_f)
          )
        end
        unless payroll.save
          flash[:messages] = "Errors: #{payroll.errors.full_messages}"
          flash[:class] = 'flash-error'
          session[:payroll] = payroll
          redirect_to new_payroll_path(copy: true) and return
        end
      end
    end

    if params[:commit] == t('all_form.save_out')
      redirect_to root_path(active_tab: 'payroll') and return
    else
      redirect_to edit_payroll_path(payroll.id) and return
    end
  end

  def permit_params
    params.require(:payroll).permit(:number, :date)
  end

  def permit_details_param
    params.require(:job).permit(id: [])
  end

  def permit_save_details_param
    params.require(:details).permit(qty: [], id: [])
  end

  def find_payroll
    @payroll = Payroll.find(params[:id])
  end

  def detail_json(detail)
      {
        job: detail.job,
        o_m: detail.order_manufacturing,
        qty: detail.qty,
        qty_o_m: detail.order_manufacturing.used_jobs.select { |job, qty| break qty if job == detail.job},
        sum: detail.sum
      }
  end
end
