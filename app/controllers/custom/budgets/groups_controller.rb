require_dependency Rails.root.join("app", "controllers", "budgets", "groups_controller").to_s

class Budgets::GroupsController
  has_filters %w[not_unfeasible feasible unfeasible unselected selected winners not_selected], only: :show
end


