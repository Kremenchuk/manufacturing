class AddAreaVolume < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :area, :float
    add_column :items, :volume, :float
  end
end
