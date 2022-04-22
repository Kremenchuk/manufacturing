class Worker < ApplicationRecord

  has_many :payrolls, dependent: :destroy

  validates :fio, presence: true
  validates :position, presence: true

end
