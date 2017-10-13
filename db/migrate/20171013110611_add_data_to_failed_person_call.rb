class AddDataToFailedPersonCall < ActiveRecord::Migration
  def change
    add_column :failed_person_calls, :name, :string
    add_column :failed_person_calls, :first_surname, :string
  end
end
