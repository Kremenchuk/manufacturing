class AddPrintInCollectionToJobs < ActiveRecord::Migration[5.0]
  def change
    add_column :jobs, :print_in_collection, :boolean, default: true
    add_column :users, :locale, :string, default: :ru
  end
end
