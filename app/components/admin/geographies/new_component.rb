class Admin::Geographies::NewComponent < ApplicationComponent
  include Header
  attr_reader :geography

  def initialize(geography)
    @geography = geography
  end

  private

    def title
      t("admin.geographies.new.title")
    end
end
