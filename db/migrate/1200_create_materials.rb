class CreateMaterials < ActiveRecord::Migration[5.0]
  def change
    create_table :materials do |t|
      t.string	:name,      null: false
      t.integer	:unit,      null: false, default: 0
      t.float	  :price,     null: false
      t.float   :weight,    null: false
      t.float   :area
      t.float   :volume
      t.integer :size_l
      t.integer :size_a
      t.integer :size_b
      t.text    :note
      t.float   :qty,       default: 0.0
      t.timestamps
    end
  end
end
