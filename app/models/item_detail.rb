class ItemDetail < ApplicationRecord

  belongs_to :item
  belongs_to :item_detailable, polymorphic: true
end
