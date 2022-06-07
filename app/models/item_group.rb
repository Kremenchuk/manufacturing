# == Schema Information
#
# Table name: item_groups
#
#  id         :integer          not null, primary key
#  name       :string           not null
#  range      :integer          default(0)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class ItemGroup < ApplicationRecord
  has_many :items

  default_scope { order(created_at: :asc) }

  validates :name, :range,
            presence: true

  validates :name,
            uniqueness: true
end
