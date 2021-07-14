class Material < ApplicationRecord
  enum unit: ['шт', 'м/п', 'кг']

  default_scope { order(qty: :desc) }

  has_many :order_manufacturings_details, as: :order_manufacturings_detailable


  has_many :purchase_invoices_details
  has_many :purchase_invoices, through: :purchase_invoices_details

  validates :name, :unit, :price, :weight,
            presence: true

  validates :name,
            uniqueness: true
end
