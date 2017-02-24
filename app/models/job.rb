class Job < ApplicationRecord


  validates :name, :price, :time,
            presents: true
end
