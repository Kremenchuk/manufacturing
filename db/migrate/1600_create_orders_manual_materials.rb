class CreateOrdersManualMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :orders_manual_materials do |t|
      t.belongs_to :order_manufacturing
      t.belongs_to :material
      t.float      :qty
      t.timestamps
    end
  end
end
