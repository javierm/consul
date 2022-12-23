class Layout::SubnavigationComponent < ApplicationComponent
  delegate :content_block, :layout_menu_link_to, :multitenancy_management_mode?, to: :helpers

  def render?
    !multitenancy_management_mode?
  end
end
