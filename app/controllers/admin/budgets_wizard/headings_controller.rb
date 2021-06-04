class Admin::BudgetsWizard::HeadingsController < Admin::BaseController
  include Admin::BudgetHeadingsActions

  before_action :load_headings, only: [:index, :create]
  before_action :set_budget_mode

  def index
    @heading = @group.headings.new
  end

  private

    def headings_index
      if @mode == "multiple"
        admin_budgets_wizard_budget_group_headings_path(@budget, @group, url_params)
      else
        admin_budgets_wizard_budget_budget_phases_path(@budget, url_params)
      end
    end

    def new_action
      :index
    end

    def url_params
      @mode.present? ? { mode: @mode } : {}
    end

    def set_budget_mode
      @mode = params[:mode] || params.dig(:budget, :mode)
    end
end
