I18n.available_locales.each do |locale|
  next if SiteCustomization::ContentBlock.find_by(locale: locale, name: "top_links")

  I18n.with_locale(locale) do
    SiteCustomization::ContentBlock.create!(
      locale: locale,
      name: "top_links",
      body: %Q{
        <li>
          <a href="https://transparencia.santiagodecompostela.gal/portada/#{locale}">
            #{I18n.t("sites.transparency.title")}
          </a>
        </li>
        <li>
          <a href="https://datos.santiagodecompostela.gal/#{locale}">
            #{I18n.t("sites.open_data.title")}
          </a>
        </li>
      }
    )
  end
end

social_links = {
  es: { lg: "cas", weather: "El Tiempo" },
  gl: { lg: "gal", weather: "O Tempo" }
}

social_links.each do |locale, texts|
  next if SiteCustomization::ContentBlock.find_by(locale: locale, name: "footer")

  SiteCustomization::ContentBlock.create!(
    locale: locale,
    name: "footer",
    body: %Q{
      <li class="inline-block">
        <a href="http://www.santiagodecompostela.gal/tempo.php?lg=#{texts[:lg]}" title="#{texts[:weather]}">
          <span class="show-for-sr">#{texts[:weather]}</span>
          <span class="icon-otempo" aria-hidden="true"></span>
        </a>
      </li>
    }
  )
end
