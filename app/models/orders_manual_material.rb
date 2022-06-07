# == Schema Information
#
# Table name: orders_manual_materials
#
#  id                     :integer          not null, primary key
#  qty                    :float
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  material_id            :integer
#  order_manufacturing_id :integer
#
# Indexes
#
#  index_orders_manual_materials_on_material_id             (material_id)
#  index_orders_manual_materials_on_order_manufacturing_id  (order_manufacturing_id)
#
class OrdersManualMaterial < ApplicationRecord
  # Матеріали які при відправці в роботу списуються зі складу
  belongs_to :order_manufacturing
  belongs_to :material
end
