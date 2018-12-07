class Setting < ActiveRecord::Base
  validates :key, presence: true, uniqueness: true

  default_scope { order(id: :asc) }
  scope :banner_style, -> { where("key ilike ?", "banner-style.%")}
  scope :banner_img, -> { where("key ilike ?", "banner-img.%")}

  def type
    if feature_flag?
      'feature'
    elsif banner_style?
      'banner-style'
    elsif banner_img?
      'banner-img'
    else
      'common'
    end
  end

  def feature_flag?
    key.start_with?('feature.')
  end

  def enabled?
    feature_flag? && value.present?
  end

  def banner_style?
    key.start_with?('banner-style.')
  end

  def banner_img?
    key.start_with?('banner-img.')
  end

  class << self
    def [](key)
      where(key: key).pluck(:value).first.presence
    end

    def []=(key, value)
      setting = where(key: key).first || new(key: key)
      setting.value = value.presence
      setting.save!
      value
    end

    def defaults
      {
        "official_level_1_name":                                    "Empleados públicos", # For the moderation console
        "official_level_2_name":                                    "Organización Municipal",
        "official_level_3_name":                                    "Directores generales",
        "official_level_4_name":                                    "Concejales",
        "official_level_5_name":                                    "Alcaldesa",
        "max_ratio_anon_votes_on_debates":                          50,
        "max_votes_for_debate_edit":                                1000,
        "max_votes_for_proposal_edit":                              1000,
        "comments_body_max_length":                                 1000,
        "proposal_code_prefix":                                     'MAD',
        "votes_for_proposal_success":                               53726,
        "months_to_archive_proposals":                              12,
        "email_domain_for_officials":                               '', # Users with this email domain (including subdomains) will automatically be marked as level 1 officials
        "per_page_code_head":                                       '',
        "per_page_code_body":                                       '',
        "twitter_handle":                                           "abriendomadrid",
        "twitter_hashtag":                                          "#decidemadrid",
        "facebook_handle":                                          "Abriendo-Madrid-1475577616080350",
        "youtube_handle":                                           "channel/UCFmaChI9quIY7lwHplnacfg",
        "telegram_handle":                                          nil,
        "instagram_handle":                                         "decidemadrid",
        "blog_url":                                                 "https://diario.madrid.es/decidemadrid/",
        "transparency_url":                                         "http://transparencia.madrid.es/",
        "opendata_url":                                             "http://datos.madrid.es/",
        "url":                                                      "https://decide.madrid.es", # Public-facing URL of the app.
        "org_name":                                                 "Decide Madrid",
        "place_name":                                               "Madrid",
        "meta_title":                                               nil,
        "meta_description":                                         nil,
        "meta_keywords":                                            nil,
        "feature.debates":                                          true,
        "feature.proposals":                                        true,
        "feature.featured_proposals":                               true,
        "feature.spending_proposals":                               nil,
        "feature.polls":                                            true,
        "feature.twitter_login":                                    true,
        "feature.facebook_login":                                   true,
        "feature.google_login":                                     true,
        "feature.public_stats":                                     true,
        "feature.budgets":                                          true,
        "feature.signature_sheets":                                 true,
        "feature.legislation":                                      true,
        "feature.user.recommendations":                             true,
        "feature.user.recommendations_on_debates":                  true,
        "feature.user.recommendations_on_proposals":                true,
        "feature.community":                                        true,
        "feature.map":                                              nil,
        "feature.allow_images":                                     true,
        "feature.allow_attached_documents":                         true,
        "feature.guides":                                           nil,
        "feature.help_page":                                        true,
        "feature.spending_proposal_features.phase1":                true,
        "feature.spending_proposal_features.phase2":                nil,
        "feature.spending_proposal_features.phase3":                nil,
        "feature.spending_proposal_features.voting_allowed":        nil,
        "feature.spending_proposal_features.final_voting_allowed":  true,
        "feature.spending_proposal_features.open_results_page":     nil,
        "feature.spending_proposal_features.valuation_allowed":     nil,
        "banner-style.banner-style-one":                            "Banner style 1",
        "banner-style.banner-style-two":                            "Banner style 2",
        "banner-style.banner-style-three":                          "Banner style 3",
        "banner-img.banner-img-one":                                "Banner image 1",
        "banner-img.banner-img-two":                                "Banner image 2",
        "banner-img.banner-img-three":                              "Banner image 3",
        "proposal_notification_minimum_interval_in_days":           3,
        "direct_message_max_per_day":                               3, # For proposal notifications
        "mailer_from_name":                                         'CONSUL',
        "mailer_from_address":                                      'noreply@consul.dev',
        "verification_offices_url":                                 'http://www.madrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Atencion-al-ciudadano/Oficinas-de-Atencion-al-Ciudadano?vgnextfmt=default&vgnextchannel=5b99cde2e09a4310VgnVCM1000000b205a0aRCRD',
        "min_age_to_participate":                                   16,
        "min_age_to_verify":                                        16,
        "featured_proposals_number":                                3,
        "proposal_improvement_path":                                nil,
        "map_latitude":                                             40.4332002,
        "map_longitude":                                            -3.7009591,
        "map_zoom":                                                 10,
        "related_content_score_threshold":                          -0.3,
        "feature.user.skip_verification":                           'true',
        "feature.homepage.widgets.feeds.proposals":                 true,
        "feature.homepage.widgets.feeds.debates":                   true,
        "feature.homepage.widgets.feeds.processes":                 true
      }
    end
  end
end
