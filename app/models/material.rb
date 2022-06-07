# == Schema Information
#
# Table name: materials
#
#  id               :integer          not null, primary key
#  area             :float
#  manual_write_off :boolean          default(FALSE)
#  name             :string           not null
#  note             :text
#  price            :float            not null
#  qty              :float            default(0.0)
#  round_one        :boolean          default(FALSE)
#  size_a           :integer
#  size_b           :integer
#  size_l           :integer
#  unit             :integer          default("шт"), not null
#  volume           :float
#  weight           :float            not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
class Material < ApplicationRecord

  has_many :item_details, as: :detailable
  has_many :purchase_invoices_details
  has_many :purchase_invoices, through: :purchase_invoices_details
  has_many :orders_manual_materials
  has_many :order_manufacturings, through: :orders_manual_materials

  validates :name, :unit, :price, :weight,
            presence: true

  validates :name,
            uniqueness: true

  enum unit: ['шт', 'м/п', 'кг']

  default_scope { order(qty: :asc) }

  def as_json(options = nil)
    {
      id: id,
      name: name,
      unit: unit,
      price: price,
      weight: weight
    }
  end

end
