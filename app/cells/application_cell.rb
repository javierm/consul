class ApplicationCell < Cell::ViewModel
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper
  include SettingsHelper

  def controller_name
    params[:controller]
  end
end
