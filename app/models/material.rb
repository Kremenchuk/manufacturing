class Material < ApplicationRecord
  enum unit: ['шт', 'м/п', 'кг']

  default_scope { order(created_at: :desc) }

  has_many :order_manufacturings_details, as: :order_manufacturings_detailable

  validates :name, :unit, :price, :weight,
            presence: true

  validates :name,
            uniqueness: true
end
