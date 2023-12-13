class Admin::Settings::ParticipationProcessesTabComponent < ApplicationComponent
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end
end
