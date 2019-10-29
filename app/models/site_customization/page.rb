class SiteCustomization::Page < ApplicationRecord
  VALID_STATUSES = %w[draft published].freeze
  has_many :cards,
    class_name:  "Widget::Card",
    foreign_key: "site_customization_page_id",
    inverse_of:  :page

  extend Mobility
  translates :title,       touch: true
  translates :subtitle,    touch: true
  translates :content,     touch: true
  include Translatable

  validates_translation :title, presence: true
  validates :slug, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: /\A[0-9a-zA-Z\-_]*\Z/, message: :slug_format }
  validates :status, presence: true, inclusion: { in: VALID_STATUSES }

  scope :published, -> { where(status: "published").sort_desc }
  scope :sort_asc, -> { order("id ASC") }
  scope :sort_desc, -> { order("id DESC") }
  scope :with_more_info_flag, -> { where(status: "published", more_info_flag: true).sort_asc }
  scope :with_same_locale, -> { i18n.locale }
  scope :locale, -> { where("site_customization_page_translations.locale": I18n.locale) }

  def url
    "/#{slug}"
  end
end
