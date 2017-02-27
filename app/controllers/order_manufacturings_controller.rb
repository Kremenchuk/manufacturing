class OrderManufacturingsController < ApplicationController
  layout false

  def index
    @order_manufacturings = OrderManufacturing.all.page params[:page]
    respond_to do |format|
      # format.html
      format.js
    end
  end
end
