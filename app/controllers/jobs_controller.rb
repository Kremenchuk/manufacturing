class JobsController < ApplicationController


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

  def new
    @job = Job.new
  end

  def edit

  end

  def create
    Job.create(permit_params)
    redirect_to root_path(active_tab: 'job')
  end

  private

  def permit_params
    params.require(:job).permit(:name, :price, :time, :print)
  end


end
