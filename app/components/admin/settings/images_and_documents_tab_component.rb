class Admin::Settings::ImagesAndDocumentsTabComponent < ApplicationComponent
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end
end
