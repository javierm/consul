class RenameUserNameAttribute < ActiveRecord::Migration
  def change
    rename_column :users, :name, :common_name
    rename_column :failed_person_calls, :name, :common_name
  end
end
