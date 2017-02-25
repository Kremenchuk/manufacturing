class CreatePayrolls < ActiveRecord::Migration[5.0]
  def change
    create_table :payrolls do |t|
      t.belongs_to :worker
      t.belongs_to :order_manufacturing_detail
      t.string :date,       null: false
      t.float  :qty,        null: false
      t.float  :sum,        null: false

      t.timestamps
    end
  end
end
