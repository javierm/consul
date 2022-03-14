# NOTE: I18n.backend.reload!
class Welcome::FinancedDomainsComponent < ApplicationComponent
  DATA = Rails.configuration.deploy['financed_domains']
  CITY = Rails.configuration.deploy['city']

  def has_cards?
    cards_count > 0
  end

  def cards_count
    DATA.dig('cards')&.size || 0
  end

  def header
    translation('header')
  end

  def image(name)
    File.join 'financed_domains', name
  end

  def cards
    DATA['cards'].map do |card|
      {
        image: image(card['image']),
        title: translation(card['i18n'])
      }
    end
  end

  def translation(keys)
    t("welcome.financed_domains.#{CITY}.#{Array(keys).join(".")}")
  end

  def bg_image
    image DATA['bg_image']
  end

end
