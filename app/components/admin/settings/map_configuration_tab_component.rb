class Admin::Settings::MapConfigurationTabComponent < ApplicationComponent
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end
end
