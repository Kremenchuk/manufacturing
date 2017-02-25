class Payroll < ApplicationRecord

  belongs_to :worker
  belongs_to :order_manufacturing_detail


  validates :date, :qty, :sum,
      presence: true
end
