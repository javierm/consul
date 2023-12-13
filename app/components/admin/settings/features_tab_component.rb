class Admin::Settings::FeaturesTabComponent < ApplicationComponent
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end
end
