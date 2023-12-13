class Admin::Settings::MapConfigurationTabComponent < ApplicationComponent
  def settings
    Setting.with_prefix("map")
  end
end
