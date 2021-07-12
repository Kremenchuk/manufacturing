class AddColumsPurchaseInvoices < ActiveRecord::Migration[5.0]
  def change
    add_column :purchase_invoices, :note, :text
  end
end
