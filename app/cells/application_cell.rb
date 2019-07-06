class ApplicationCell < Cell::ViewModel
  include ERB::Util
  include Cocoon::ViewHelpers
  include ActionView::Helpers::UrlHelper
  include ActionView::Helpers::TranslationHelper
  include SettingsHelper

  def self.locals(*params)
    params.each do |param|
      define_method param do
        model[param]
      end
    end
  end

  def controller_name
    params[:controller]
  end

  private
    def helper_renderer
      # TODO: use when cocoon calls `render`
      Object.new.tap do |_object|
        include ActionView::Helpers::RenderingHelper
      end
    end
end
