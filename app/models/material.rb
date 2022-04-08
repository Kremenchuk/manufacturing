class Material < ApplicationRecord

  has_many :item_details, as: :detailable
  has_many :purchase_invoices_details
  has_many :purchase_invoices, through: :purchase_invoices_details
  has_many :orders_manual_materials
  has_many :order_manufacturings, through: :orders_manual_materials

  validates :name, :unit, :price, :weight,
            presence: true

  validates :name,
            uniqueness: true

  enum unit: ['шт', 'м/п', 'кг']

  default_scope { order(qty: :asc) }

end
