class OrderManufacturing < ApplicationRecord


  has_many :item_order_manufacturings
  has_many :items, through: :items_order_manufacturings
  has_many :o_m_details

  validates :number, :date,
            presents: true
end
