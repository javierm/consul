class ApplicationCell < Cell::ViewModel
  include ERB::Util
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper
  include SettingsHelper

  def self.locals(*params)
    params.each do |param|
      define_method param do
        options[param]
      end
    end
  end

  def controller_name
    params[:controller]
  end
end
