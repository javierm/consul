class Admin::Widget::Cards::NewComponent < ApplicationComponent
  include Header
  attr_reader :card

  def initialize(card)
    @card = card
  end

  private

    def title
      if card.header?
        t("admin.homepage.new.header_title")
      else
        t("admin.homepage.new.card_title")
      end
    end
end
