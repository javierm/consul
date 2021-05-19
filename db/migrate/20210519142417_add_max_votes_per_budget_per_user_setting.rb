class AddMaxVotesPerBudgetPerUserSetting < ActiveRecord::Migration[5.1]
  def up
    Setting.create(key: 'max_votes_per_budget_per_user', value: 10)
  end

  def down
    Setting.find_by(key: 'max_votes_per_budget_per_user').destroy
  end
end
