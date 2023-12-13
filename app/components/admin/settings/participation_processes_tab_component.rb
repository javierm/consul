class Admin::Settings::ParticipationProcessesTabComponent < ApplicationComponent
  def settings
    Setting.with_prefix("process")
  end
end
