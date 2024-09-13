class Layout::FooterComponent < ApplicationComponent; end

load Rails.root.join("app", "components", "layout", "footer_component.rb")

class Layout::FooterComponent
  use_helpers :image_path_for
end
