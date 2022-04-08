class CreateItemDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :item_details do |t|
      t.belongs_to :item, null: false
      t.references :detailable, polymorphic: true
      t.float :qty, default: 0.0, null: false
      t.boolean :print_in_o_m, default: true
      t.timestamps
    end

    Item.find_each do |item|
      item.details.each do |detail|
        ItemDetail.create!(
          item_id: item.id,
          detailable_id: detail[0].to_i,
          detailable_type: detail[1],
          qty: detail[2].to_f,
          print_in_o_m: detail[3]
        )
      end
    end

    remove_column :items, :details
  end
end
