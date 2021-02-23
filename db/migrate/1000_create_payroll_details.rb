class CreatePayrollDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :payroll_details do |t|
      t.belongs_to :order_manufacturing
      t.belongs_to :payroll
      t.belongs_to :job
      t.float  :qty,        null: false
      t.float  :sum,        null: false

      t.timestamps
    end
  end
end
