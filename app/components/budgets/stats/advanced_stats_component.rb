class Budgets::Stats::AdvancedStatsComponent < ApplicationComponent
  attr_reader :stats

  def initialize(stats)
    @stats = stats
  end

  def render?
    stats.advanced?
  end

  private

    def headings
      stats.budget.headings.sort_by_name
    end
end
