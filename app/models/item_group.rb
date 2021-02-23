class ItemGroup < ApplicationRecord
  has_many :items

  default_scope { order(created_at: :asc) }

  validates :name, :range,
            presence: true

  validates :name,
            uniqueness: true
end
