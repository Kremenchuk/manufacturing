class OrderManufacturing < ApplicationRecord

  default_scope { order(created_at: :desc) }

  has_many :order_manufacturings_details, dependent: :destroy
  has_many :items, through: :order_manufacturings_details
  belongs_to :counterparty

  validates :number, :date,
            presence: true

  validates :number,
      uniqueness: true

  def price
    order_manufacturing_price = 0
    if self.order_manufacturings_details.present?
      self.order_manufacturings_details.each do |details|
        order_manufacturing_price += details.item.price
      end
    end
    return order_manufacturing_price
  end

  def weight
    order_manufacturing_weight = 0
    if self.order_manufacturings_details.present?
      self.order_manufacturings_details.each do |details|
        order_manufacturing_weight += details.item.weight
      end
    end
    return order_manufacturing_weight
  end

  def volume
    order_manufacturing_volume = 0
    if self.order_manufacturings_details.present?
      self.order_manufacturings_details.each do |details|
        order_manufacturing_volume += details.item.volume
      end
    end
    return order_manufacturing_volume
  end

end
