require_dependency Rails.root.join("app", "controllers", "budgets_controller").to_s

class BudgetsController
  has_filters %w[not_unfeasible feasible unfeasible unselected selected winners not_selected], only: :show
end

