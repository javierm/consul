class Layout::FooterComponent < ApplicationComponent; end

load Rails.root.join("app", "components", "layout", "footer_component.rb")

class Layout::FooterComponent
  use_helpers :image_path_for

  private

    def cookies_setup_page_enabled?
      feature?("feature.cookies_consent") && feature?("cookies_consent.setup_page")
    end
end
