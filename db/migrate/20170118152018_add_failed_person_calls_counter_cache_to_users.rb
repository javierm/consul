class AddFailedPersonCallsCounterCacheToUsers < ActiveRecord::Migration
  def change
    add_column :users, :failed_person_calls_count, :integer, default: 0
  end
end
