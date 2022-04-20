class Worker < ApplicationRecord

  has_many :payrolls, dependent: :destroy

  validates :fio, :position,
            presence: true

end
