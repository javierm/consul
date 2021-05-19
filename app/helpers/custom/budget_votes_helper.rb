module Custom::BudgetVotesHelper
  def budget_votes_select_options
    Budget::VOTE_TYPES.map { |ph| [ t("budgets.vote.#{ph}"), ph ] }
  end

  def namespaced_budget_investment_unvote_path(investment, options = {})
    case namespace
    when "management"
      unvote_management_budget_investment_path(investment.budget, investment, options)
    else
      unvote_budget_investment_path(investment.budget, investment, options)
    end
  end

  def namespaced_budget_investment_vote_path(investment, options = {})
    case namespace
    when "management"
      vote_management_budget_investment_path(investment.budget, investment, options)
    else
      vote_budget_investment_path(investment.budget, investment, options)
    end
  end
end
