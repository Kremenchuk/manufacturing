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
    add_returning_path
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
    if @counterparty.order_manufacturings.present? || @counterparty.purchase_invoices.present?
      flash[:messages] = t('counterparties.cant_delete')
      flash[:class] = 'flash-error'
      redirect_to edit_counterparty_path(@counterparty)
    else
      @counterparty.destroy!
      flash[:messages] = "'#{@counterparty.name}' #{t('all_form.deleted')}"
      flash[:class] = 'flash-success'
      redirect_to root_path(active_tab: 'counterparty')
    end
  end

  private


  def find_counterparty
    @counterparty = Counterparty.find(params[:id])
  end

  def permit_params
    params.require(:counterparty).permit(:name, :short_name, :c_type)
  end

end
