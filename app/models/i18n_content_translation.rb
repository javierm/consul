class I18nContentTranslation < ApplicationRecord
  def self.existing_languages
    distinct.pluck(:locale)
  end
end
