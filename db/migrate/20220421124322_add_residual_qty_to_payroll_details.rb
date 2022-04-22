class AddResidualQtyToPayrollDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :payroll_details, :residual_qty, :float, default: 0
  end
end
