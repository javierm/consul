class BudgetsController < ApplicationController
  include FeatureFlags
  include BudgetsHelper
  feature_flag :budgets

  before_action :load_budget, only: :show
  before_action :load_current_budget, only: :index
  before_action :load_investments, only: [:index, :show]
  load_and_authorize_resource

  respond_to :html, :js

  def show
    raise ActionController::RoutingError, "Not Found" unless budget_published?(@budget)
  end

  def index
    @finished_budgets = @budgets.finished.order(created_at: :desc)
  end

  private

    def load_budget
      @budget = Budget.find_by_slug_or_id! params[:id]
    end

    def load_current_budget
      @budget = current_budget
    end

    def load_investments
      @investments = @budget&.investments_preview_list
      @investments ||= @current_budget&.investments_preview_list
    end
end
