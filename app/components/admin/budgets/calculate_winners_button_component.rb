class Admin::Budgets::CalculateWinnersButtonComponent < ApplicationComponent
  attr_reader :budget, :from_investments

  def initialize(budget, from_investments: false)
    @budget = budget
    @from_investments = from_investments
  end

  private

    def display_button?
      budget.balloting_or_later?
    end

    def action(action_name, **options)
      render Admin::ActionComponent.new(action_name, budget, **options)
    end

    def text
      if budget.investments.winners.empty?
        t("admin.budgets.winners.calculate")
      else
        t("admin.budgets.winners.recalculate")
      end
    end

    def html_class
      "button hollow float-right clear" if from_investments
    end
end
