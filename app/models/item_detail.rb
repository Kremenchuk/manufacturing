class ItemDetail < ApplicationRecord

  belongs_to :detailable, polymorphic: true
  belongs_to :item

  validates :qty, presence: true
  validates :item_id, presence: true
  validates :detailable_id, presence: true
  validates :detailable_type, presence: true
end
