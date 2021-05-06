class CounterpartiesController < ApplicationController

  before_action :permit_params, only: [:create, :update]
  before_action :find_counterparty, only: [:edit, :update, :destroy]

  def index
    data_hash = {
        view_context: view_context,
        sort_column: %w[name short_name c_type],
        model: Counterparty,
        search_query: 'UPPER(name) like :search or UPPER(short_name) like :search'
    }

    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(data_hash) }
    end
  end


  def new
    @counterparty = Counterparty.new
  end

  def edit
  end

  def update
    @counterparty.attributes = permit_params
    @counterparty.save!
    redirect_to root_path(active_tab: 'counterparty')
  end

  def create
    Counterparty.create(permit_params)
    redirect_to root_path(active_tab: 'counterparty')
  end

  def destroy
    @counterparty.destroy!
    flash[:messages] = "'#{@counterparty.name}' удалено"
    flash[:class] = 'flash-success'
    redirect_to root_path(active_tab: 'counterparty')
  end

  private


  def find_counterparty
    @counterparty = Counterparty.find(params[:id])
  end

  def permit_params
    params.require(:counterparty).permit(:name, :short_name, :c_type)
  end

end
