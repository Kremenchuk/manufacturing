class Worker < ApplicationRecord


  validates :first_name, :last_name, :position,
            presents: true

end
