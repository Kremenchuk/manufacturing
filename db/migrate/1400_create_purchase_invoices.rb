class CreatePurchaseInvoices < ActiveRecord::Migration[5.0]
  def change
    create_table :purchase_invoices do |t|
      t.belongs_to :counterparty
      t.string     :number,      null: false
      t.string     :date,        null: false
      t.float      :total_price, null: false
      t.float      :we_pay,      null: false
      t.integer    :p_i_status,  default: 0
      t.timestamps
    end
  end
end
