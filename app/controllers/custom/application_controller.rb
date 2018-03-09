require_dependency Rails.root.join('app', 'controllers', 'application_controller').to_s

class ApplicationController
  def set_locale
    # Force spanish until we implement english
    locale = :es
  end
end
