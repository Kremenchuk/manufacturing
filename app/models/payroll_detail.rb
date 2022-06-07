# == Schema Information
#
# Table name: payroll_details
#
#  id                     :integer          not null, primary key
#  qty                    :float            not null
#  residual_qty           :float            default(0.0)
#  sum                    :float            not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  job_id                 :integer
#  order_manufacturing_id :integer
#  payroll_id             :integer
#
# Indexes
#
#  index_payroll_details_on_job_id                  (job_id)
#  index_payroll_details_on_order_manufacturing_id  (order_manufacturing_id)
#  index_payroll_details_on_payroll_id              (payroll_id)
#
class PayrollDetail < ApplicationRecord

  belongs_to :order_manufacturing
  belongs_to :payroll
  belongs_to :job

  validates :residual_qty, :qty, :sum, presence: true

  default_scope { order(order_manufacturing_id: :asc) }

end
