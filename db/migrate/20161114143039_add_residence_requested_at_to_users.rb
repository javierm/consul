class AddResidenceRequestedAtToUsers < ActiveRecord::Migration
  def change
    add_column :users, :residence_requested_at, :datetime
  end
end
