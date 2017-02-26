class OrderManufacturing < ApplicationRecord


  has_many :item_order_manufacturings
  has_many :items, through: :items_order_manufacturings
  has_many :o_m_details
  belongs_to :counterparty

  validates :number, :date,
            presence: true
end
