class CreatePurchaseInvoicesDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_invoices_details do |t|
      t.belongs_to :purchase_invoice
      t.belongs_to :material
      t.float      :qty,              null: false
      t.float      :price,            null: false
    end
  end
end
