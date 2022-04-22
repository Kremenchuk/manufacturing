class PayrollDetail < ApplicationRecord

  belongs_to :order_manufacturing
  belongs_to :payroll
  belongs_to :job

  validates :residual_qty, :qty, :sum, presence: true

  default_scope { order(order_manufacturing_id: :asc) }

end
