class OrderManufacturingController < ApplicationController
  layout false

  def index
    @user = User.all
  end
end
