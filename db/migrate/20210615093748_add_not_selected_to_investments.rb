class AddNotSelectedToInvestments < ActiveRecord::Migration[5.1]
  class Budget < ApplicationRecord; end
  class Budget::Investment < ApplicationRecord; end

  def change
    add_column :budget_investments, :not_selected_explanation, :text
    add_column :budget_investments, :not_selected_email_sent_at, :datetime

    Budget::Investment.connection.schema_cache.clear!
    Budget::Investment.reset_column_information

    Budget::Investment.where(budget_id: Budget.order(:id).last, feasibility: :unfeasible).update_all(feasibility: :not_selected)
  end
end
