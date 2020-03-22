class Admin::BudgetsWizard::Headings::GroupSwitcherComponent < ApplicationComponent
  attr_reader :group

  def initialize(group)
    @group = group
  end

  def render?
    other_groups.any?
  end

  private

    def nt(key, options = {})
      t("admin.budget_headings.group_switcher.#{key}", options)
    end
    alias_method :namespaced_translation, :nt

    def budget
      group.budget
    end

    def other_groups
      @other_groups ||= budget.groups.sort_by_name - [group]
    end

    def headings_path(group)
      admin_budgets_wizard_budget_group_headings_path(budget, group)
    end
end
