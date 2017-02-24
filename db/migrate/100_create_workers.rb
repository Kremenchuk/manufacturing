class CreateWorkers < ActiveRecord::Migration[5.0]
  def change
    create_table :workers do |t|
      t.string	:first_name, null: false
      t.string	:middle_name
      t.string	:last_name,  null: false
      t.string	:position,   null: false

      t.timestamps
    end
  end
end
