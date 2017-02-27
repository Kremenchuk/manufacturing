class Worker < ApplicationRecord


  validates :first_name, :last_name, :position,
            presence: true

end
