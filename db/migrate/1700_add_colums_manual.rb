class AddColumsManual < ActiveRecord::Migration[5.0]
  def change
    add_column :materials, :manual_write_off, :boolean,    default: false
    add_column :materials, :round_one, :boolean,    default: false

  end
end
