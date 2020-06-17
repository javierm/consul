class SubnavigationComponent < ApplicationComponent
  include LayoutsHelper

  private

    def content_block(name, locale)
      SiteCustomization::ContentBlock.block_for(name, locale)
    end
end
