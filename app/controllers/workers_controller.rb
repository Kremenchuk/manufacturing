class WorkersController < ApplicationController

  before_action :find_worker, only: [:edit, :update, :destroy]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[fio position],
        model: Worker,
        search_query: 'UPPER(fio) like :search or UPPER(position) like :search'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def new
    @worker = Worker.new
  end

  def edit
    add_returning_path
  end

  def update
    @worker.attributes = permit_params
    @worker.save!
    redirect_to root_path(active_tab: 'worker')
  end

  def create
    Worker.create(permit_params)
    redirect_to root_path(active_tab: 'worker')
  end

  def destroy
    @worker.destroy
    flash[:messages] = "'#{@worker.fio}' #{t('all_form.deleted')}"
    flash[:class] = 'flash-success'
    redirect_to root_path(active_tab: 'worker')
  end

  private

  def find_worker
    @worker = Worker.find(params[:id])
  end

  def permit_params
    params.require(:worker).permit(:fio, :position)
  end

end
