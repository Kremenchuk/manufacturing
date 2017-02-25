class Payroll < ApplicationRecord

  belongs_to :worker


  validates :date,
      presence: true
end
