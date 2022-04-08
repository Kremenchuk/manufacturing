class Job < ApplicationRecord

  has_many :item_details, as: :detailable

  validates :name, :price, :time, :name_for_print,
            presence: true

  default_scope { order(created_at: :desc) }

end
