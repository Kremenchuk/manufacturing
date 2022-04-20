class Payroll < ApplicationRecord

  default_scope { order(date: :desc) }

  belongs_to :worker
  has_many :details, class_name: PayrollDetail, dependent: :destroy


  validates :date, presence: true
end
