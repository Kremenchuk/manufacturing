class Counterparty < ApplicationRecord
  enum c_type: ['Покупатель', 'Продавец']

  has_many :order_manufacturings
end
