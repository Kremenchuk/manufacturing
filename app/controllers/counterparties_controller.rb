class CounterpartiesController < ApplicationController

  before_action :permit_params, only: [:create, :edit]

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

  def create
    Counterparty.create(permit_params)
    redirect_to root_path(active_tab: 'counterparty')
  end

  private

  def permit_params
    params.require(:counterparty).permit(:name, :short_name, :c_type)
  end

end
