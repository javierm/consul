module SiteCustomizationHelper
  def site_customization_enable_translation?(locale)
    I18nContentTranslation.existing_languages.include?(locale) || locale == I18n.locale
  end

  def site_customization_display_translation_style(locale)
    site_customization_enable_translation?(locale) ? "" : "display: none;"
  end

  # information_texts/_form
  def translation_enabled_tag(locale, enabled)
    hidden_field_tag("enabled_translations[#{locale}]", (enabled ? 1 : 0))
  end

  def translation_for_locale(content, locale)
    if content.present?
      I18nContentTranslation.find_by(
        i18n_content_id: content.id,
        locale: locale
      )&.value
    else
      false
    end
  end

  def information_texts_tabs
    [:basic, :debates, :community, :proposals, :polls, :layouts, :mailers, :management, :welcome]
  end
end
