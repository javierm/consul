class AddResponseToFailedPersonCall < ActiveRecord::Migration
  def change
    add_column :failed_person_calls, :response, :text
  end
end
