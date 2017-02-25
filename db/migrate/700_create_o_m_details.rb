class CreateOMDetails < ActiveRecord::Migration[5.0]
  def change

    create_table :o_m_details do |t|
      t.belongs_to :order_manufacturing
      t.integer :o_m_detailable_id
      t.string :o_m_detailable_type
      t.float  :qty, null: false
      t.timestamps
    end
  end
end
