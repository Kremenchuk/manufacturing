class PayrollsController < ApplicationController
  layout false

  def index
    respond_to do |format|
      format.html
      format.json { render json: DatatableClass.new(view_context) }
    end
  end
end
