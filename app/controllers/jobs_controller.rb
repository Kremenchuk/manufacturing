class JobsController < ApplicationController

  before_action :permit_params, only: [:create, :update]
  before_action :find_job, only: [:edit, :update, :destroy, :copy_job]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[name price time print],
        model: Job,
        search_query: 'UPPER(name) like :search'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def job_details_datatable
    data_hash = {
        view_context: view_context,
        sort_column: %w[name price time print],
        model: Job,
        search_query: 'UPPER(name) like :search',
        modal_query: 'nil'
    }
    if params[:ids].present?
      data_hash[:modal_query] = "id NOT IN (#{params[:ids].join(',')})"
    end

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def add_job_detail
    params.require('job').require('job_details').permit('id': [])
    @item_details = Job.find(params['job']['job_details']['id'])
  end

  def new
    @job = Job.new
    if session[:job].present?
      @job.attributes = session[:job].as_json
      session.delete(:job)
    end
  end

  def edit
  end

  def update
    @job.attributes = permit_params
    create_update_action(@job)
  end

  def destroy
    @job.destroy!
    flash[:messages] = "'#{@job.name}' удалено"
    flash[:class] = 'flash-success'
    redirect_to root_path(active_tab: 'job')
  end

  def copy_job
    @job.name = 'Новая работа'
    @job.id = nil
    session[:job] = @job.attributes
    redirect_to new_job_path
  end

  def create
    create_update_action(Job.new(permit_params))
  end

  private

  def create_update_action(job)
    begin
      job.save!
      redirect_to root_path(active_tab: 'job')
    rescue => e
      flash[:messages] = "'#{job.name}' наименование не уникально. Error: #{e}"
      flash[:class] = 'flash-error'
      flash[:class_element] = 'error-class'
      session[:job] = job
      redirect_to new_job_path(copy: true)
    end
  end

  def permit_params
    params.require(:job).permit(:name, :price, :time, :print)
  end

  def find_job
    @job = Job.find(params[:id])
  end

end
