class Admin::BudgetHeadings::HeadingsComponent < ApplicationComponent
  attr_reader :headings

  def initialize(headings)
    @headings = headings
  end

  private

    def group
      @group ||= headings.proxy_association.owner
    end

    def budget
      @budget ||= group.budget
    end

    def geography_name(heading)
      heading.geography&.name || t("admin.budget_headings.no_geography")
    end
end
