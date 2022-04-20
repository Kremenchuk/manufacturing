class ChangeDateFormatOM < ActiveRecord::Migration[5.0]
  def change
    # change_column :order_manufacturings, :finish_date, :date
    change_column :order_manufacturings, :finish_date, 'varchar USING CAST(finish_date AS date)'
  end
end
