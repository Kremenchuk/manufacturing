# == Schema Information
#
# Table name: counterparties
#
#  id         :integer          not null, primary key
#  c_type     :integer          default("Покупатель"), not null
#  name       :string           not null
#  short_name :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Counterparty < ApplicationRecord
  enum c_type: ['Покупатель', 'Продавец']

  validates :name, :short_name, :c_type,
            presence: true

  has_many :order_manufacturings

  has_many :purchase_invoices
end
