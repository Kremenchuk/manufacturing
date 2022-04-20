class ChangeColumnTypePayroll < ActiveRecord::Migration[5.0]
  def change
    change_column :payrolls, :date, 'varchar USING CAST(date AS date)'
  end
end
