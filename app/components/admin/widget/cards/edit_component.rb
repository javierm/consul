class Admin::Widget::Cards::EditComponent < ApplicationComponent
  include Header
  attr_reader :card

  def initialize(card)
    @card = card
  end

  private

    def title
      if card.header?
        t("admin.homepage.edit.header_title")
      else
        t("admin.homepage.edit.card_title")
      end
    end
end
