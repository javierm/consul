class Admin::BudgetsWizard::GroupsController < Admin::BaseController
  include Admin::BudgetGroupsActions

  before_action :load_groups, only: [:index, :create]
  before_action :set_budget_mode

  def index
    if @mode == "single"
      @group = @budget.groups.new("name_#{I18n.locale}" => @budget.name)
    else
      @group = @budget.groups.new
    end
  end

  private

    def groups_index
      if @mode == "multiple"
        admin_budgets_wizard_budget_groups_path(@budget, url_params)
      else
        admin_budgets_wizard_budget_group_headings_path(@budget, @group, url_params)
      end
    end

    def new_action
      :index
    end

    def url_params
      @mode.present? ? { mode: @mode } : {}
    end

    def set_budget_mode
      @mode = params[:mode] || params.dig(:heading, :mode)
    end
end
