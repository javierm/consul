class Admin::BudgetsWizard::Budgets::NewComponent < ApplicationComponent
  include Header
  attr_reader :budget, :mode

  def initialize(budget)
    @budget = budget
  end

  def title
    if mode == "single"
      t("admin.budgets.new.title_single")
    else
      t("admin.budgets.new.title_multiple")
    end
  end
end
