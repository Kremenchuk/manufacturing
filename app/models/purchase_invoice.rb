class PurchaseInvoice < ApplicationRecord


  default_scope { order(created_at: :desc) }


  belongs_to :counterparty

  has_many :purchase_invoices_details, dependent: :destroy
  has_many :materials, through: :purchase_invoices_details

  validates :number, :date, :total_price, :we_pay,
            presence: true

end
