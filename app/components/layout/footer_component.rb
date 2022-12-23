class Layout::FooterComponent < ApplicationComponent
  delegate :multitenancy_management_mode?, to: :helpers

  def render?
    !multitenancy_management_mode?
  end
end
