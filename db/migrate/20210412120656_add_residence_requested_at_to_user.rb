class AddResidenceRequestedAtToUser < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :residence_requested_at, :datetime
  end
end
