class Admin::Settings::SDGConfigurationTabComponent < ApplicationComponent
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end
end
