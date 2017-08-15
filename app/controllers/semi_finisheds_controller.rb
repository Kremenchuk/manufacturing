class SemiFinishedsController < ApplicationController

  before_action :find_semi_finished, only: [:edit, :update, :destroy, :copy_semi_finished]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[name unit size_l size_a size_b],
        model: SemiFinished,
        search_query: 'UPPER(name) like :search'
    }
    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end

  def new
    @semi_finished = SemiFinished.new
    if session[:semi_finished].present?
      @semi_finished.attributes = session[:semi_finished].as_json
      @semi_finished_details = SemiFinishedDetail.new
      session.delete(:semi_finished)
    end
  end

  def edit
    @semi_finished_details = @semi_finished.semi_finished_details
    save_semi_finished_details
  end

  def create
    SemiFinished.create(permit_params)
    save_semi_finished_details
    redirect_to root_path(active_tab: 'semi_finished')
  end

  def update
    @semi_finished.update!(permit_params)
    save_semi_finished_details
    redirect_to root_path(active_tab: 'semi_finished')
  end

  def destroy

  end

  def copy_semi_finished
    @semi_finished.name = 'Новый полуфабрикат'
    @semi_finished.id = nil
    session[:semi_finished] = @semi_finished.attributes
    redirect_to new_item_path
  end

  def add_semi_finished_details
    params.permit('entity')
    case params[:entity]
      when 'job'
        params.require('job').require('job_details').permit('id': [])
        @semi_finished_details = Job.find(params['job']['job_details']['id'])
      when 'material'
        params.require('material').permit('id')
        @semi_finished_details = Material.find(params['material']['id'])
    end
  end

  private

  def save_semi_finished_details

  end

  def permit_params
    attributes = params.require(:semi_finished).permit(:id, :name, :unit, :price, :size_a, :size_b,:note)
    attributes[:price] = attributes[:price].gsub(',', '.')
    return attributes
  end

  def find_semi_finished
    @semi_finished = SemiFinished.find(params[:id])
  end

end
