class Job < ApplicationRecord

  after_destroy :delete_from_item_details

  has_many :order_manufacturings_details, as: :order_manufacturings_detailable

  validates :name, :price, :time, :name_for_print,
            presence: true


  def delete_from_item_details
    ItemDetail.where(item_detailable_id: id, item_detailable_type: 'Job').destroy_all
  end

end
