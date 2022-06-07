# == Schema Information
#
# Table name: purchase_invoices
#
#  id              :integer          not null, primary key
#  date            :string           not null
#  note            :text
#  number          :string           not null
#  p_i_status      :integer          default(0)
#  total_price     :float            not null
#  we_pay          :float            not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  counterparty_id :integer
#
# Indexes
#
#  index_purchase_invoices_on_counterparty_id  (counterparty_id)
#
class PurchaseInvoice < ApplicationRecord


  default_scope { order(created_at: :desc) }


  belongs_to :counterparty

  has_many :purchase_invoices_details, dependent: :destroy
  has_many :materials, through: :purchase_invoices_details

  validates :number, :date, :total_price, :we_pay,
            presence: true

end
