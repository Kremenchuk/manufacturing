class PurchaseInvoicesDetail < ApplicationRecord


  belongs_to :purchase_invoice
  belongs_to :material

  validates :qty, :price,
            presence: true
end
