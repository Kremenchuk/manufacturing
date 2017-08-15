class Material < ApplicationRecord
  enum unit: ['шт', 'м/п', 'кг']

  default_scope { order(created_at: :desc) }


  validates :name, :unit, :price, :weight,
            presence: true

  validates :name,
            uniqueness: true
end
