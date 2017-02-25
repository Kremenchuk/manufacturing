class OMDetail < ApplicationRecord

  belongs_to :order_manufacturing

  validates :qty,
            presence: true
end
