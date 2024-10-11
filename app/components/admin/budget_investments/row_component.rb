class Admin::BudgetInvestments::RowComponent < ApplicationComponent
  attr_reader :investment
  use_helpers :can?

  def initialize(investment)
    @investment = investment
  end

  private

    def budget
      investment.budget
    end
end
