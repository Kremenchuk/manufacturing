class OrderManufacturingsDetail < ApplicationRecord


  # default_scope { order(position: :asc) }

  belongs_to :order_manufacturing
  belongs_to :item

  validates :qty,
            presence: true
end
