class OrderManufacturing < ApplicationRecord


  has_many :items_order_manufacturings
  has_many :items, through: :items_order_manufacturings

  validates :number, :date,
            presents: true
end
