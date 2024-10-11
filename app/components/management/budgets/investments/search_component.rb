class Management::Budgets::Investments::SearchComponent < ApplicationComponent
  attr_reader :budget, :action
  use_helpers :budget_heading_select_options

  def initialize(budget, action:)
    @budget = budget
    @action = action
  end

  private

    def url
      url_for(
        controller: "management/budgets/investments",
        action: action,
        budget_id: budget.id
      )
    end
end