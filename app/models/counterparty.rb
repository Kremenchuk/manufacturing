class Counterparty < ApplicationRecord
  enum c_type: [:buyer, :provider]

  has_many :order_manufacturings
end
