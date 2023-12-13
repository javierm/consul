class Admin::Settings::RemoteCensusConfigurationTabComponent < ApplicationComponent
  def general_settings
    Setting.with_prefix("remote_census.general")
  end

  def request_settings
    Setting.with_prefix("remote_census.request")
  end

  def response_settings
    Setting.with_prefix("remote_census.response")
  end
end
