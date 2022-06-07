# == Schema Information
#
# Table name: purchase_invoices_details
#
#  id                  :integer          not null, primary key
#  price               :float            not null
#  qty                 :float            not null
#  material_id         :integer
#  purchase_invoice_id :integer
#
# Indexes
#
#  index_purchase_invoices_details_on_material_id          (material_id)
#  index_purchase_invoices_details_on_purchase_invoice_id  (purchase_invoice_id)
#
class PurchaseInvoicesDetail < ApplicationRecord


  belongs_to :purchase_invoice
  belongs_to :material

  validates :qty, :price,
            presence: true
end
