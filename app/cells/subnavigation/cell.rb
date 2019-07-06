class Subnavigation::Cell < ApplicationCell
  include LayoutsHelper

  def show
    render
  end

  private

    def content_block(name, locale)
      SiteCustomization::ContentBlock.block_for(name, locale)
    end
end
