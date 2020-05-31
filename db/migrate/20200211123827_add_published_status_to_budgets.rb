class AddPublishedStatusToBudgets < ActiveRecord::Migration[5.1]
  def change
    add_column :budgets, :published, :boolean
  end
end
