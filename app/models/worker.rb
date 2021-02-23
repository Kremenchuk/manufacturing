class Worker < ApplicationRecord


  validates :fio, :position,
            presence: true

end
