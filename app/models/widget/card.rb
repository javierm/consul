class Widget::Card < ApplicationRecord
  include Imageable
  belongs_to :page,
    class_name:  "SiteCustomization::Page",
    foreign_key: "site_customization_page_id",
    inverse_of:  :cards

  # table_name must be set before calls to 'translates'
  self.table_name = "widget_cards"

  extend Mobility
  translates :label,       touch: true
  translates :title,       touch: true
  translates :description, touch: true
  translates :link_text,   touch: true
  include Translatable

  def self.header
    where(header: true)
  end

  def self.body
    where(header: false, site_customization_page_id: nil).order(:created_at)
  end
end
