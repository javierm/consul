class Budgets::MapComponent < ApplicationComponent
  delegate :render_map, to: :helpers
  attr_reader :budget

  def initialize(budget)
    @budget = budget
  end

  def render?
    feature?(:map) && !budget.informing?
  end

  private

    def coordinates
      return unless budget.present?

      if budget.publishing_prices_or_later? && budget.investments.selected.any?
        investments = budget.investments.selected
      else
        investments = budget.investments
      end

      MapLocation.where(investment_id: investments).map(&:json_data)
    end

    def polygons_data
      budget.geographies.map do |geography|
        {
          outline_points: geography.outline_points,
          color: geography.color,
          headings: geography.headings.map do |heading|
            link_to heading.name_with_budget,
              budget_investments_path(heading.budget, heading_id: heading.id)
          end
        }
      end
    end
end
