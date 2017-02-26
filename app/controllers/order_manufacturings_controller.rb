class OrderManufacturingsController < ApplicationController
  layout false

  def index
    @order_manufacturings = OrderManufacturing.all.page params[:upcoming_page]
    respond_to do |format|
      format.js
      format.html

    end
  end
end
