class CreateOrderManufacturingDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_manufacturing_details do |t|
      t.belongs_to :items_order_manufacturing
      t.integer :order_manufacturing_detailable_id
      t.string :order_manufacturing_detailable_type
      t.float  :qty, null: false
      t.timestamps
    end
  end
end
