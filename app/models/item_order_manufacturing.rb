class ItemOrderManufacturing < ApplicationRecord

  belongs_to :item
  belongs_to :order_manufacturing

  validates :qty,
            presents: true
end
