class OrderManufacturingDetail < ApplicationRecord

  belongs_to :items_order_manufacturing

  validates :qty,
            presence: true
end
