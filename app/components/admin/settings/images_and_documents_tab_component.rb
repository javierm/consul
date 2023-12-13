class Admin::Settings::ImagesAndDocumentsTabComponent < ApplicationComponent
  def settings
    Setting.with_prefix("uploads")
  end
end
