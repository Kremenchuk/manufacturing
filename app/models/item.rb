class Item < ApplicationRecord


  default_scope { order(created_at: :desc) }

  enum item_type: ['Коробчатый', 'Складской', 'Тележка', 'Другое']
  enum unit: ['шт', 'м/п', 'кг', '%']
  enum for_sale: ['Не для продажи', 'Для продажи']

  has_many :order_manufacturings_details
  has_many :order_manufacturings, through: :order_manufacturings_details

  belongs_to :item_group


  validates :name, :unit, :item_group,
            presence: true

  validates :name,
            uniqueness: true


  def price
     eval_field(self, 'price')
  end

  def weight
    eval_field(self, 'weight')
  end

  # def area
  #   eval_field(self, 'area')
  # end
  #
  # def volume
  #   eval_field(self, 'volume')
  # end

  def eval_field(item, field_name)
    item_field = 0
    if item.details.present?
      item.details.each do |item_details|
        case item_details[1]
          when 'Job'
            next
          when 'Material'
            material = Material.find(item_details[0])
            if material.send(field_name).present?
              item_field += material.send(field_name) * item_details[2]
            end
          when 'Item'
            detail_item = Item.find(item_details[0])
            item_field += eval_field(detail_item, field_name) * item_details[2]
        end
      end
   end
    return item_field
  end

end
