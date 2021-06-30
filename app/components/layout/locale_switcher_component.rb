class Layout::LocaleSwitcherComponent < ApplicationComponent
  delegate :name_for_locale, :current_path_with_query_params, to: :helpers

  def render?
    locales.size > 1
  end

  private

    def many_locales?
      locales.size > 4
    end

    def locales
      I18n.available_locales
    end

    def label
      t("layouts.header.locale")
    end

    def label_id
      "locale_switcher_label"
    end

    def language_items
      safe_join(locales.map { |locale| tag.li { locale_link(locale) } })
    end

    def locale_link(locale)
      link_to name_for_locale(locale),
        current_path_with_query_params(locale: locale),
        lang: locale,
        "aria-current" => (true if locale == I18n.locale)
    end

    def language_options
      locales.map do |locale|
        [name_for_locale(locale), current_path_with_query_params(locale: locale), { lang: locale }]
      end
    end
end
