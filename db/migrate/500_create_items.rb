class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string	:name,      null: false
      t.integer	:unit,      null: false, default: 0
      t.boolean :for_sale, default: true
      t.float   :size_l
      t.float   :size_a
      t.float   :size_b
      t.json :details, default: {}
      t.belongs_to	:item_group
      t.timestamps
    end
    add_index :items, :name, :unique => true
  end
end
