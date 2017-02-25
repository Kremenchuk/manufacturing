class Item < ApplicationRecord
  enum item_type: [:stillage, :material, :semifinished]

  has_many :item_order_manufacturings
  has_many :order_manufacturings, through: :items_order_manufacturings
  has_many :item_details #под вопросом
  has_many :item_details, as: :item_detailable


  validates :name, :unit, :price, :weight,
            presence: true
end
