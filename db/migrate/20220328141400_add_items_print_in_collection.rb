class AddItemsPrintInCollection < ActiveRecord::Migration[5.0]
  def change
    add_column :items, :print_in_collection, :boolean, default: true
  end
end
