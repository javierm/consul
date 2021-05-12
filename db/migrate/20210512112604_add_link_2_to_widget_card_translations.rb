class AddLink2ToWidgetCardTranslations < ActiveRecord::Migration[5.1]
  def change
    add_column :widget_card_translations, :link_text_2, :string
    add_column :widget_card_translations, :link_url_2, :string
  end
end
