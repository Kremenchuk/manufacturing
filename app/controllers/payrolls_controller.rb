class PayrollsController < ApplicationController
  layout false

  def index
    @payrolls = Payroll.all.page params[:page]
  end
end
