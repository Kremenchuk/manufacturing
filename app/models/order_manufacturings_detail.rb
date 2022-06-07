# == Schema Information
#
# Table name: order_manufacturings_details
#
#  id                     :integer          not null, primary key
#  qty                    :float            not null
#  item_id                :integer
#  order_manufacturing_id :integer
#
# Indexes
#
#  index_order_manufacturings_details_on_item_id                 (item_id)
#  index_order_manufacturings_details_on_order_manufacturing_id  (order_manufacturing_id)
#
class OrderManufacturingsDetail < ApplicationRecord


  # default_scope { order(position: :asc) }

  belongs_to :order_manufacturing
  belongs_to :item

  validates :qty,
            presence: true
end
