class Admin::Geographies::IndexComponent < ApplicationComponent
  include Header
  attr_reader :geographies

  def initialize(geographies)
    @geographies = geographies
  end

  private

    def title
      t("admin.geographies.index.title")
    end

    def headings(geography)
      if geography.headings.any?
        geography.headings.map(:name_with_budget).join # TODO
      else
        t("admin.geographies.index.no_related_headings")
      end
    end

    def attribute_name(attribute)
      Geography.human_attribute_name(attribute)
    end
end
