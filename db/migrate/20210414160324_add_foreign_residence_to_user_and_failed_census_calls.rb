class AddForeignResidenceToUserAndFailedCensusCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :foreign_residence, :boolean
    add_column :failed_census_calls, :foreign_residence, :boolean
  end
end
