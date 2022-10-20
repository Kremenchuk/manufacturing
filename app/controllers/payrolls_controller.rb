class PayrollsController < ApplicationController

  before_action :find_payroll, only: [:edit, :update, :destroy]

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
      o_m = OrderManufacturing.find(session[:o_m_payroll_id])
      used_jobs = []
      if params[:job_ids].present?
        jobs_included_in_payroll = params[:job_ids].map { |x| Job.find(JSON.parse(x.gsub("'",'"'))["job_id"]) if JSON.parse(x.gsub("'",'"'))["o_m_id"].to_i == o_m.id }.compact
        used_jobs = o_m.used_jobs_by_payrolls.map do |used_job|
          unless jobs_included_in_payroll.include? used_job[:job]
            { job: used_job[:job], residual_qty: used_job[:residual_qty], qty_in_o_m: used_job[:qty_in_o_m]}
          end
        end
      else
        used_jobs = o_m.used_jobs_by_payrolls
      end

      data_hash[:o_m] = o_m
      data_hash[:model_data] = used_jobs.compact
      # session.delete(:o_m_payroll_id)
      if data_hash[:model_data].present?
        response = DatatableClass.new(data_hash).with_out_model
      else
        response = DatatableClass.new(data_hash).empty_response
      end
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
      permit_details_param[:id].each_with_index do |value, index|
        add_to_table = JSON.parse(value.gsub("'",'"'))
        selected_o_m = OrderManufacturing.find(add_to_table["o_m_id"])
        selected_job = Job.find(add_to_table["job_id"])
        qty_o_m, residual_qty = selected_o_m.used_jobs_by_payrolls.select do | used_job |
          break used_job[:qty_in_o_m], used_job[:residual_qty] if used_job[:job] == selected_job
        end
        @payroll_details << {
          job: selected_job,
          o_m: selected_o_m,
          qty: 0,
          residual_qty: residual_qty,
          qty_o_m: qty_o_m,
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
        if params[:details].present?
          permit_save_details_param[:id].each_with_index do |value, index|
            add_to_table = JSON.parse(value.gsub("'",'"'))
            selected_job = Job.find(add_to_table["job_id"])
            if permit_save_details_param[:qty][index].to_f > permit_save_details_param[:residual_qty][index].to_f
              qty = permit_save_details_param[:residual_qty][index].to_f
            else
              qty = permit_save_details_param[:qty][index].to_f
            end
            PayrollDetail.create(
              order_manufacturing: OrderManufacturing.find(add_to_table["o_m_id"]),
              job: selected_job,
              payroll: payroll,
              residual_qty: permit_save_details_param[:residual_qty][index].to_f,
              qty: qty,
              sum: Float(selected_job.price.to_f * qty)
            )
          end
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
    params.require(:details).permit(qty: [], id: [], qty_in_o_m: [], residual_qty: [])
  end

  def find_payroll
    @payroll = Payroll.find(params[:id])
  end

  def detail_json(detail)
    residual_qty = recalculate_residual_qty(detail)
      {
        job: detail.job,
        o_m: detail.order_manufacturing,
        qty: detail.qty,
        residual_qty: residual_qty,
        qty_o_m: detail.order_manufacturing.used_jobs.select { |job, qty| break qty if job == detail.job},
        sum: detail.sum
      }
  end

  def recalculate_residual_qty(detail)
    new_residual_qty = detail.order_manufacturing.used_jobs_by_payrolls(detail).select do | used_job |
      break used_job[:residual_qty] if used_job[:job] == detail.job
    end
    if new_residual_qty.present?
      if detail.qty < new_residual_qty
        new_residual_qty
      else
        detail.qty
      end
    else
      detail.residual_qty
    end
  end
end
