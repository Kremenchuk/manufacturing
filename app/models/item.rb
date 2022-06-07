# == Schema Information
#
# Table name: items
#
#  id                  :integer          not null, primary key
#  area                :float
#  for_sale            :boolean          default(NULL)
#  item_files          :json
#  name                :string           not null
#  print_in_collection :boolean          default(TRUE)
#  size_a              :float
#  size_b              :float
#  size_l              :float
#  unit                :integer          default("шт"), not null
#  volume              :float
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  item_group_id       :integer
#
# Indexes
#
#  index_items_on_item_group_id  (item_group_id)
#  index_items_on_name           (name) UNIQUE
#
class Item < ApplicationRecord

  has_many :item_details, as: :detailable
  has_many :item_details, dependent: :destroy

  has_many :order_manufacturings_details
  has_many :order_manufacturings, through: :order_manufacturings_details

  belongs_to :item_group

  validates :name, :unit, :item_group,
            presence: true

  validates :name,
            uniqueness: true

  default_scope { order(created_at: :desc) }

  enum item_type: ['Коробчатый', 'Складской', 'Тележка', 'Другое']
  enum unit: ['шт', 'м/п', 'кг', 'комп.']
  enum for_sale: ['Не для продажи', 'Для продажи']

  mount_uploaders :item_files, ItemUploader

  def item_materials(filter_by_print = false, qty_multiplier = 1)
    find_in_item(self, 'Material', filter_by_print, qty_multiplier)
  end

  def item_jobs(filter_by_print = false, qty_multiplier = 1)
    find_in_item(self, 'Job', filter_by_print, qty_multiplier)
  end

  def item_items(filter_by_print = false, qty_multiplier = 1)
    find_in_item(self, 'Item', filter_by_print, qty_multiplier)
  end

  def all_used_materials(qty_multiplier = 1)
    find_all_type_in_item(self, 'Material', qty_multiplier)
  end

  def all_used_jobs(qty_multiplier = 1)
    find_all_type_in_item(self, 'Job', qty_multiplier)
  end

  def all_used_items(qty_multiplier = 1)
    find_all_type_in_item(self, 'Item', qty_multiplier)
  end

  def price
     eval_field(self, 'price',).to_f.round(2)
  end

  def weight
    eval_field(self, 'weight').to_f.round(2)
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
    if item.item_details.present?
      item.item_details.each do |item_detail|
        case item_detail.detailable_type
          when 'Job'
            if field_name == 'price'
              job = Job.find(item_detail.detailable_id)
              if job.send(field_name).present?
                item_field += job.send(field_name) * item_detail.qty
              end
            else
              next
            end
          when 'Material'
            material = Material.find(item_detail.detailable_id)
            if material.send(field_name).present?
              item_field += material.send(field_name) * item_detail.qty
            end
          when 'Item'
            detail_item = Item.find(item_detail.detailable_id)
            item_field += eval_field(detail_item, field_name) * item_detail.qty
        end
      end
   end
    return item_field
  end

  private

  def find_in_item(item, type, filter_by_print = false, qty_multiplier = 1)
    query_param = { detailable_type: type }
    if filter_by_print
      query_param[:print_in_o_m] = true
    end
    item.item_details.where(query_param).map { |x| {"entity": x.detailable, qty: (x.qty * qty_multiplier), print_in_o_m: x.print_in_o_m } }
  end

  def find_all_type_in_item(item, type, qty = 1)
    result = []
    items_on_current_iteration = []
    result.concat(find_in_item(item, type, false, qty))
    items_on_current_iteration.concat(find_in_item(item, 'Item', qty))
    items_on_current_iteration.each do |second_item|
      # qty *= second_item[:qty]
      result << [second_item[:entity], (qty * second_item[:qty]), second_item[:print_in_o_m]] if type == 'Item'
      unless find_in_item(second_item[:entity], type).empty?
        result.concat(find_all_type_in_item(second_item[:entity], type, (qty * second_item[:qty])))
      end
    end
    result
  end

end
