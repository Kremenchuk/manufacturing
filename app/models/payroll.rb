class Payroll < ApplicationRecord

  default_scope { order(date: :desc) }

  belongs_to :worker
  has_many :details, class_name: PayrollDetail, dependent: :destroy

  validates :date, presence: true

  def sum
    self.details.sum(:sum)
  end

end
