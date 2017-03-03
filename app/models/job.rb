class Job < ApplicationRecord

  has_many :item_details, as: :item_detailable

  validates :name, :price, :time,
            presence: true
end
