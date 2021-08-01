class OrdersManualMaterial < ApplicationRecord

  belongs_to :order_manufacturing
  belongs_to :material
end
