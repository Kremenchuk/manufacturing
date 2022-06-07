# == Schema Information
#
# Table name: payrolls
#
#  id         :integer          not null, primary key
#  date       :string           not null
#  number     :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  worker_id  :integer
#
# Indexes
#
#  index_payrolls_on_worker_id  (worker_id)
#
class Payroll < ApplicationRecord

  default_scope { order(date: :desc) }

  belongs_to :worker
  has_many :details, class_name: PayrollDetail, dependent: :destroy

  validates :date, presence: true

  def sum
    self.details.sum(:sum)
  end

end
