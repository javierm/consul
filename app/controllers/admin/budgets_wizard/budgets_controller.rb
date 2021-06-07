class Admin::BudgetsWizard::BudgetsController < Admin::BaseController
  include Translatable
  include FeatureFlags
  feature_flag :budgets

  load_and_authorize_resource

  before_action :set_budget_mode

  def new
    @mode ||= "multiple"
  end

  def edit
  end

  def create
    @budget.published = false

    if @budget.save
      redirect_to groups_index, notice: t("admin.budgets.create.notice")
    else
      render :new
    end
  end

  def update
    if @budget.update(budget_params)
      redirect_to groups_index, notice: t("admin.budgets.update.notice")
    else
      render :edit
    end
  end

  private

    def budget_params
      params.require(:budget).permit(*allowed_params)
    end

    def allowed_params
      valid_attributes = [:currency_symbol, :voting_style, administrator_ids: [], valuator_ids: []]

      valid_attributes + [translation_params(Budget)]
    end

    def groups_index
      admin_budgets_wizard_budget_groups_path(@budget, mode: @mode)
    end

    def set_budget_mode
      if params[:mode] || budget_heading_params.present?
        @mode = params[:mode] || budget_heading_params[:mode]
      end
    end
end
