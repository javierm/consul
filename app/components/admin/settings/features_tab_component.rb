class Admin::Settings::FeaturesTabComponent < ApplicationComponent
  def settings
    Setting.with_prefix("feature")
  end
end
