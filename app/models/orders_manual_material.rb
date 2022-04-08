class OrdersManualMaterial < ApplicationRecord
  # Матеріали які при відправці в роботу списуються зі складу
  belongs_to :order_manufacturing
  belongs_to :material
end
