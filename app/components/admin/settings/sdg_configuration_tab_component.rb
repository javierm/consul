class Admin::Settings::SDGConfigurationTabComponent < ApplicationComponent
  def settings
    Setting.with_prefix("sdg")
  end
end
