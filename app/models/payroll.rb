class Payroll < ApplicationRecord

  default_scope { order(created_at: :desc) }

  belongs_to :worker


  validates :date,
      presence: true
end
