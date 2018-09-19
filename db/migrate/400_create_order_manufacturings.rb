class CreateOrderManufacturings < ActiveRecord::Migration[5.0]
  def change
    create_table :order_manufacturings do |t|
      t.string	:number,    null: false
      t.string	:date,      null: false
      t.string	:invoice
      t.text	  :note
      t.belongs_to :counterparty
      t.belongs_to :user

      t.timestamps
    end
  end
end
