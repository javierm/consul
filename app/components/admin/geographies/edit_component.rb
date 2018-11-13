class Admin::Geographies::EditComponent < ApplicationComponent
  include Header
  attr_reader :geography

  def initialize(geography)
    @geography = geography
  end

  private

    def title
      geography.name
    end
end
