class CreateCounterparies < ActiveRecord::Migration[5.0]
  def change
    create_table :counterparies do |t|
      t.string	:name,            null:false
      t.string	:short_name,      null:false
      t.integer	:c_type,          null:false, default: 0

      t.timestamps
    end
  end
end
