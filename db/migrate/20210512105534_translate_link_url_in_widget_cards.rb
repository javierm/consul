class TranslateLinkUrlInWidgetCards < ActiveRecord::Migration[5.1]
  def change
    add_column :widget_card_translations, :link_url, :string
    remove_column :widget_cards, :link_url, :string
  end
end
