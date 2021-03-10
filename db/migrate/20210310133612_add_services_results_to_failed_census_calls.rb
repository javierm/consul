class AddServicesResultsToFailedCensusCalls < ActiveRecord::Migration[5.1]
  def change
    add_column :failed_census_calls, :services_results, :jsonb
  end
end
