class Item < ApplicationRecord

  after_destroy :delete_from_item_details

  default_scope { order(created_at: :desc) }

  enum item_type: ['Коробчатый', 'Складской', 'Тележка', 'Другое']
  enum unit: ['шт', 'м/п', 'кг', '%']
  enum for_sale: ['Не для продажи', 'Для продажи']

  has_many :order_manufacturings_details, as: :order_manufacturings_detailable


  validates :name, :unit,
            presence: true

  validates :name,
            uniqueness: true


  #
  # def price
  #   if self.item_price.present?
  #     self.item_price.value
  #   else
  #     eval_filed(self, 'item_price')
  #   end
  # end
  #
  # def weight
  #   if self.item_weight.present?
  #     self.item_weight.value
  #   else
  #     eval_filed(self, 'item_weight')
  #   end
  # end
  #
  # def area
  #   if self.item_area.present?
  #     self.item_area.value
  #   else
  #     eval_filed(self, 'item_area')
  #   end
  # end
  #
  # def volume
  #   if self.item_volume.present?
  #     self.item_volume.value
  #   else
  #     eval_filed(self, 'item_volume')
  #   end
  # end

  # def price= value
  #   if value.present? && Float(value) != 0.0
  #     ItemPrice.find_or_initialize_by(item: self).tap do |f|
  #       f.value = value
  #       f.save!
  #     end
  #   end
  # end
  #
  # def weight= value
  #   if value.present? && Float(value) != 0.0
  #     ItemWeight.find_or_initialize_by(item: self).tap do |f|
  #       f.value = value
  #       f.save!
  #     end
  #   end
  # end
  #
  # def area= value
  #   if value.present? && Float(value) != 0.0
  #     ItemArea.find_or_initialize_by(item: self).tap do |f|
  #       f.value = value
  #       f.save!
  #     end
  #   end
  # end
  #
  # def volume= value
  #   if value.present? && Float(value) != 0.0
  #     ItemVolume.find_or_initialize_by(item: self).tap do |f|
  #       f.value = value
  #       f.save!
  #     end
  #   end
  # end

  def item_details_list(item = nil, object = nil)
    if object.present?
      ItemDetail.find_by(item_id: item.id, item_detailable_id: object.id, item_detailable_type: object.class.to_s)
    else
      ItemDetail.where(item_id: id).map do |item_detail|
        item_detail.item_detailable_type.constantize.find(item_detail.item_detailable_id)
      end
    end
  end

  def remove_item_details
    ItemDetail.where(item: self).destroy_all
  end

  private

  def delete_from_item_details
    ItemDetail.where(item_id: id).destroy_all
    ItemDetail.where(item_detailable_id: id, item_detailable_type: 'Item').destroy_all
  end

  def eval_filed(item, field_name)
    percents = Array.new
    item_field = 0
    if item.item_details_list.present?
      item.item_details_list.each do |detail_item|

          if detail_item.class == Item
            if detail_item.send(field_name).present?
              if detail_item.unit == '%' && field_name == 'item_price'
                percents << detail_item.send(field_name).value.to_f
              end
              if detail_item.item_type == 'Материал'
                item_field += detail_item.send(field_name).value.to_f * item.item_details_list(self, detail_item).qty.to_f
              else
                item_field += eval_filed(detail_item, field_name)
              end
            end
          else
            if field_name == 'item_price'
              item_field += detail_item.price.to_f * item.item_details_list(self, detail_item).qty.to_f
            end
          end
      end

      if percents.present?
        percents.each do |percent|
          item_field = item_field + (item_field / 100.0) * percent
        end
      end
    end
    return item_field
  end




end
