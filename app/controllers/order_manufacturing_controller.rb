class OrderManufacturingController < ApplicationController
  layout false

  def index
    @order_manufacturings = OrderManufacturing.all.page params[:page]
  end
end
