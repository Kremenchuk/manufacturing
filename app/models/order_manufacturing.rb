class OrderManufacturing < ApplicationRecord
  require 'carrierwave/orm/activerecord'
  default_scope -> { order(o_m_status: :asc, finish_date: :desc) }

  has_many :order_manufacturings_details, dependent: :destroy
  has_many :items, through: :order_manufacturings_details
  belongs_to :counterparty
  belongs_to :user
  has_many :orders_manual_materials, dependent: :destroy
  has_many :materials, through: :orders_manual_materials


  validates :number, :start_date, :finish_date,
            presence: true

  validates :number,
      uniqueness:  { scope: [:start_date, :finish_date] }

  mount_uploaders :o_m_files, OmUploader

  enum o_m_status: %i(no_status in_progress produced shipped)

  def price
    begin
    order_manufacturing_price = 0.0
    if self.order_manufacturings_details.present?
      self.order_manufacturings_details.each do |details|
        order_manufacturing_price += details.item.price.nil? ? 0.0 : (details.item.price * details.qty)
      end
    end
    return order_manufacturing_price.to_f.round(2)
    rescue
    end
  end

  def weight
    begin
    order_manufacturing_weight = 0.0
    if self.order_manufacturings_details.present?
      self.order_manufacturings_details.each do |details|
        order_manufacturing_weight += details.item.weight.nil? ? 0.0 : details.item.weight
      end
    end
    return order_manufacturing_weight.to_f.round(2)
    rescue
    end
  end

  def volume
    begin
    order_manufacturing_volume = 0.0
    if self.order_manufacturings_details.present?
      self.order_manufacturings_details.each do |details|
        order_manufacturing_volume += details.item.volume.nil? ? 0.0 : details.item.volume
      end
    end
    return order_manufacturing_volume.to_f
      rescue
    end
  end

  def used_materials
    o_m_used_materials = Array.new
    self.order_manufacturings_details.each do |stillage|
      o_m_used_materials << stillage.item.all_used_materials(stillage.qty)
    end

    # Объединение одинаковых материалов
    o_m_used_materials = DataOperation.marge_unit(o_m_used_materials.flatten(1))

    # округление количеств материалов для которых задана настройка
    o_m_used_materials.each_with_index do |used_material, index|
      if used_material[0].round_one
        o_m_used_materials[index][1] = o_m_used_materials[index][1].ceil
      end
    end
    o_m_used_materials
  end

  def used_jobs
    o_m_used_jobs = Array.new
    self.order_manufacturings_details.each do |stillage|
      o_m_used_jobs << stillage.item.all_used_jobs(stillage.qty)
    end

    # Объединение одинаковых работ
    o_m_used_jobs = DataOperation.marge_unit(o_m_used_jobs.flatten(1))

    return o_m_used_jobs
  end


private

  # def marge_unit(unit_array)
  #   unit_array = unit_array.flatten(1)
  #   sum_unit = Array.new
  #   for i in 0..(unit_array.size - 1)
  #     if unit_array[i].nil?
  #       next
  #     else
  #       unit_qty = unit_array[i][1]
  #     end
  #     for j in (i+1)..(unit_array.size - 1)
  #       if unit_array[i].present? and unit_array[j].present?
  #         if unit_array[i][0].id == unit_array[j][0].id
  #           unit_qty = unit_qty + unit_array[j][1]
  #           unit_array[j] = nil
  #         end
  #       end
  #     end
  #     sum_unit << [unit_array[i][0], unit_qty]
  #   end
  #
  #   return sum_unit
  # end


end

