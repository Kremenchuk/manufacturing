class CreateItemGroups < ActiveRecord::Migration[5.0]
  def change
    create_table :item_groups do |t|
      t.string :name,      null: false
      t.integer :range,    default: 0
      t.timestamps
    end
  end
end
