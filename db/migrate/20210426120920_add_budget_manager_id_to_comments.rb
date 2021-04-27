class AddBudgetManagerIdToComments < ActiveRecord::Migration[5.1]
  def change
    add_column :comments, :budget_manager_id, :integer
  end
end
