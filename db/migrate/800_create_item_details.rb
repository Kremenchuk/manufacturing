class CreateItemDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :item_details do |t|
      t.belongs_to :item
      t.integer :item_detailable_id
      t.string :item_detailable_type
      t.float :qty, null: false

      t.timestamps
    end
  end
end
