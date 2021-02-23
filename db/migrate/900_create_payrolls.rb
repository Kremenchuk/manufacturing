class CreatePayrolls < ActiveRecord::Migration[5.0]
  def change
    create_table :payrolls do |t|
      t.belongs_to :worker
      t.integer :number
      t.string :date,       null: false

      t.timestamps
    end
  end
end
