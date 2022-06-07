# == Schema Information
#
# Table name: item_details
#
#  id              :integer          not null, primary key
#  detailable_type :string
#  print_in_o_m    :boolean          default(TRUE)
#  qty             :float            default(0.0), not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  detailable_id   :integer
#  item_id         :integer          not null
#
# Indexes
#
#  index_item_details_on_detailable_type_and_detailable_id  (detailable_type,detailable_id)
#  index_item_details_on_item_id                            (item_id)
#
class ItemDetail < ApplicationRecord

  belongs_to :detailable, polymorphic: true
  belongs_to :item

  validates :qty, presence: true
  validates :item_id, presence: true
  validates :detailable_id, presence: true
  validates :detailable_type, presence: true
end
