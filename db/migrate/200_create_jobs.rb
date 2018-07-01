class CreateJobs < ActiveRecord::Migration[5.0]
  def change
    create_table :jobs do |t|
      t.string	:name,            null: false
      t.string	:name_for_print,  null: false
      t.float	  :price,           null: false
      t.integer	:time,            null: false

      t.timestamps
    end
  end
end
