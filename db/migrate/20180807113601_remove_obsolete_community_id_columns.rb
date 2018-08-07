class RemoveObsoleteCommunityIdColumns < ActiveRecord::Migration
  def change
    remove_column :proposals, :community_id
    remove_column :budget_investments, :community_id
  end
end
