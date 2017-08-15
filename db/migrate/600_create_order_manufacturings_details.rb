class CreateOrderManufacturingsDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_manufacturings_details do |t|
      t.belongs_to :order_manufacturing
      t.integer :order_manufacturings_detailable_id
      t.string :order_manufacturings_detailable_type
      t.float  :qty, null: false
    end
  end
end
