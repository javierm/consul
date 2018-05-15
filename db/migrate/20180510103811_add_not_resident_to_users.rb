class AddNotResidentToUsers < ActiveRecord::Migration
  def change
    add_column :users, :no_resident, :boolean, default: false
  end
end
