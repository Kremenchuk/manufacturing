class HomeController < ApplicationController

  def index
    @order_manufacturings = OrderManufacturing.all
    @payrolls = Payroll.all
  end
end
