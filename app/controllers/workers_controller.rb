class WorkersController < ApplicationController

  before_action :find_worker, only: [:edit, :update]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[first_name last_name middle_name position],
        model: Worker,
        search_query: 'UPPER(first_name) like :search or UPPER(middle_name) like :search or UPPER(last_name) like :search or UPPER(position) like :search'
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

  private

  def find_worker
    @worker = Worker.find(params[:id])
  end

  def permit_params
    params.require(:worker).permit(:first_name, :middle_name, :last_name, :position)
  end

end
