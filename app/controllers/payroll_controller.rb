class PayrollController < ApplicationController
  layout false

  def index
    @payrolls = Payroll.all.page params[:page]
  end
end
