class Counterparty < ApplicationRecord
  enum c_type: ['Покупатель', 'Продавец']

  validates :name, :short_name, :c_type,
            presence: true

  has_many :order_manufacturings

  has_many :purchase_invoices
end
