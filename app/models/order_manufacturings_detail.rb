class OrderManufacturingsDetail < ApplicationRecord


  # default_scope { order(position: :asc) }

  belongs_to :order_manufacturing
  belongs_to :order_manufacturings_detailable, polymorphic: true

  validates :qty,
            presence: true
end
