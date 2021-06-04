class Admin::Budgets::FormComponent < ApplicationComponent
  include TranslatableFormHelper
  include GlobalizeHelper

  attr_reader :budget
  delegate :display_calculate_winners_button?,
           :calculate_winner_button_text,
           :calculate_winners_admin_budget_path,
           to: :helpers

  def initialize(budget)
    @budget = budget
  end

  def voting_styles_select_options
    Budget::VOTING_STYLES.map do |style|
      [Budget.human_attribute_name("voting_style_#{style}"), style]
    end
  end

  def currency_symbol_select_options
    Budget::CURRENCY_SYMBOLS.map { |cs| [cs, cs] }
  end

  def phases_select_options
    Budget::Phase::PHASE_KINDS.map { |ph| [t("budgets.phase.#{ph}"), ph] }
  end

  private

    def admins
      @admins ||= Administrator.includes(:user)
    end

    def valuators
      @valuators ||= Valuator.includes(:user).order(description: :asc).order("users.email ASC")
    end
end