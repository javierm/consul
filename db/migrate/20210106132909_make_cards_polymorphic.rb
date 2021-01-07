class MakeCardsPolymorphic < ActiveRecord::Migration[5.2]
  def change
    change_table :widget_cards do |t|
      t.rename :site_customization_page_id, :page_id
      t.string :page_type, default: "SiteCustomization::Page"
    end
  end
end
