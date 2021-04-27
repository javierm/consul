require_dependency Rails.root.join("app", "controllers", "valuation", "budget_investments_controller").to_s

class Valuation::BudgetInvestmentsController < Valuation::BaseController
  private

    def restrict_access
      unless current_user.administrator? || current_user.budget_manager? || current_budget.valuating?
        raise CanCan::AccessDenied.new(I18n.t("valuation.budget_investments.not_in_valuating_phase"))
      end
    end

    def restrict_access_to_assigned_items
      return if current_user.administrator? || current_user.budget_manager? ||
                Budget::ValuatorAssignment.exists?(investment_id: params[:id],
                                                   valuator_id: current_user.valuator.id)

      raise ActionController::RoutingError.new("Not Found")
    end
end
