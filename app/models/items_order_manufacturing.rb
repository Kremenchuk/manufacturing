class ItemsOrderManufacturing < ApplicationRecord

  has_many :order_manufacturing_details
  belongs_to :item
  belongs_to :order_manufacturing

  validates :qty,
            presents: true
end
