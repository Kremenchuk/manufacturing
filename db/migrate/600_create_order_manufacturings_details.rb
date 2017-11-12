class CreateOrderManufacturingsDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :order_manufacturings_details do |t|
      t.belongs_to :order_manufacturing
      t.belongs_to :item
      t.float  :qty, null: false
    end
  end
end
