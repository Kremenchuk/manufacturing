class PayrollDetail < ApplicationRecord

  belongs_to :order_manufacturing
  belongs_to :payroll
  belongs_to :job

  validates :qty, :sum,
      presence: true
end
