class Job < ApplicationRecord

  default_scope { order(created_at: :desc) }

  has_many :order_manufacturings_details, as: :order_manufacturings_detailable

  validates :name, :price, :time, :name_for_print,
            presence: true



end
