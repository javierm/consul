class Admin::Geographies::FormComponent < ApplicationComponent
  attr_reader :geography

  def initialize(geography)
    @geography = geography
  end

  private

    def headings
      Budget::Heading.all
    end
end
