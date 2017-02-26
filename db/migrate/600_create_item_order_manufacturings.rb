class CreateItemOrderManufacturings < ActiveRecord::Migration[5.0]
  def change
    create_table :item_order_manufacturings do |t|
      t.belongs_to :item
      t.belongs_to :order_manufacturings
      t.float      :qty,    null: false
    end
  end
end
