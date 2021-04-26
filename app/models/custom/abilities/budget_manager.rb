module Abilities
  class BudgetManager
    include CanCan::Ability

    def initialize(user)
      can :comment_as_administrator, [Budget::Investment]

      can [:index, :read, :new, :create, :update, :destroy, :calculate_winners], Budget
      can [:read, :create, :update, :destroy], Budget::Group
      can [:read, :create, :update, :destroy], Budget::Heading
      can [:hide, :admin_update, :toggle_selection], Budget::Investment
      can [:valuate, :comment_valuation], Budget::Investment
      cannot [:admin_update, :toggle_selection, :valuate, :comment_valuation],
        Budget::Investment, budget: { phase: "finished" }

      can :create, Budget::ValuatorAssignment

      can :read_admin_stats, Budget, &:balloting_or_later?
    end
  end
end
