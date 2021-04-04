class CreateOrderManufacturings < ActiveRecord::Migration[5.0]
  def change
    create_table :order_manufacturings do |t|
      t.string	   :number,    null: false
      t.string	   :start_date,      null: false
      t.string	   :finish_date,     null: false
      t.string	   :invoice
      t.text	     :note
      t.integer    :o_m_status, default: 0
      t.float      :total_price
      t.float      :con_pay
      t.float      :extra_charge
      t.float      :indirect_costs
      t.float      :payroll_taxes
      t.belongs_to :counterparty
      t.belongs_to :user
      t.json       :o_m_files
      t.timestamps
    end
  end
end
