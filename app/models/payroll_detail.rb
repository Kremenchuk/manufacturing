class PayrollDetail < ApplicationRecord

  belongs_to :om_detail
  belongs_to :payroll

  validates :qty, :sum,
      presence: true
end
