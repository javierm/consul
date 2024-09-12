class Layout::TopLinksComponent < ApplicationComponent; end

load Rails.root.join("app", "components", "layout", "top_links_component.rb")

class Layout::TopLinksComponent
  use_helpers :current_user

  def render?
    true
  end
end
