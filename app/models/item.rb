class Item < ApplicationRecord
  enum item_type: [:stillage, :material, :semifinished]

  has_many :items_order_manufacturings
  has_many :order_manufacturings, through: :items_order_manufacturings


  validates :name, :unit, :price, :weight,
            presence: true
end
