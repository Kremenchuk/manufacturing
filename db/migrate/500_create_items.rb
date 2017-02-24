class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.string	:name,      null: false
      t.string	:unit,      null: false
      t.integer :item_type, default: 1
      t.float	  :area
      t.float	  :price,     null: false
      t.float	  :volume
      t.float	  :weight,    null: false

      t.timestamps
    end
  end
end
