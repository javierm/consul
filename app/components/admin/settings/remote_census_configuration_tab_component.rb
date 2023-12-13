class Admin::Settings::RemoteCensusConfigurationTabComponent < ApplicationComponent
  attr_reader :general_settings, :request_settings, :response_settings

  def initialize(general_settings:, request_settings:, response_settings:)
    @general_settings = general_settings
    @request_settings = request_settings
    @response_settings = response_settings
  end
end
