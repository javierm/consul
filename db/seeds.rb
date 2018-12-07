# coding: utf-8
# Default admin user (change password after first deploy to a server!)
if Administrator.count == 0 && !Rails.env.test?
  admin = User.create!(username: 'admin', email: 'admin@consul.dev', password: '12345678', password_confirmation: '12345678', confirmed_at: Time.current, terms_of_service: "1")
  admin.create_administrator
end

Setting["official_level_1_name"] = "Empleados públicos" # For the moderation console
Setting["official_level_2_name"] = "Organización Municipal"
Setting["official_level_3_name"] = "Directores generales"
Setting["official_level_4_name"] = "Concejales"
Setting["official_level_5_name"] = "Alcaldesa"

Setting["max_ratio_anon_votes_on_debates"] = 50

Setting["max_votes_for_debate_edit"] = 1000

Setting["max_votes_for_proposal_edit"] = 1000

Setting['comments_body_max_length'] = 1000

Setting["proposal_code_prefix"] = 'MAD'

Setting["votes_for_proposal_success"] = 53726

Setting["months_to_archive_proposals"] = 12

Setting["email_domain_for_officials"] = '' # Users with this email domain (including subdomains) will automatically be marked as level 1 officials

Setting['per_page_code_head'] = ''

Setting['per_page_code_body'] = ''

Setting["twitter_handle"] = "abriendomadrid"
Setting["twitter_hashtag"] = "#decidemadrid"
Setting["facebook_handle"] = "Abriendo-Madrid-1475577616080350"
Setting["youtube_handle"] = "channel/UCFmaChI9quIY7lwHplnacfg"
Setting["telegram_handle"] = nil
Setting["instagram_handle"] = "decidemadrid"
Setting["blog_url"] = "https://diario.madrid.es/decidemadrid/"
Setting["transparency_url"] = "http://transparencia.madrid.es/"
Setting["opendata_url"] = "http://datos.madrid.es/"

Setting["url"] = "https://decide.madrid.es" # Public-facing URL of the app.

Setting["org_name"] = "Decide Madrid"

Setting["place_name"] = "Madrid"

Setting["meta_title"] = nil
Setting["meta_description"] = nil
Setting["meta_keywords"] = nil

Setting['feature.debates'] = true
Setting['feature.proposals'] = true
Setting['feature.featured_proposals'] = true
Setting['feature.spending_proposals'] = nil
Setting['feature.polls'] = true
Setting['feature.twitter_login'] = true
Setting['feature.facebook_login'] = true
Setting['feature.google_login'] = true
Setting['feature.public_stats'] = true
Setting['feature.budgets'] = true
Setting['feature.signature_sheets'] = true
Setting['feature.legislation'] = true
Setting['feature.user.recommendations'] = true
Setting['feature.user.recommendations_on_debates'] = true
Setting['feature.user.recommendations_on_proposals'] = true
Setting['feature.community'] = true
Setting['feature.map'] = nil
Setting['feature.allow_images'] = true
Setting['feature.allow_attached_documents'] = true
Setting['feature.guides'] = nil
Setting['feature.help_page'] = true

Setting['feature.spending_proposal_features.phase1'] = true
Setting['feature.spending_proposal_features.phase2'] = nil
Setting['feature.spending_proposal_features.phase3'] = nil
Setting['feature.spending_proposal_features.voting_allowed'] = nil
Setting['feature.spending_proposal_features.final_voting_allowed'] = true
Setting['feature.spending_proposal_features.open_results_page'] = nil
Setting['feature.spending_proposal_features.valuation_allowed'] = nil

Setting['banner-style.banner-style-one']   = "Banner style 1"
Setting['banner-style.banner-style-two']   = "Banner style 2"
Setting['banner-style.banner-style-three'] = "Banner style 3"

Setting['banner-img.banner-img-one']   = "Banner image 1"
Setting['banner-img.banner-img-two']   = "Banner image 2"
Setting['banner-img.banner-img-three'] = "Banner image 3"


Setting['proposal_notification_minimum_interval_in_days'] = 3
Setting['direct_message_max_per_day'] = 3 # For proposal notifications

Setting['mailer_from_name'] = 'CONSUL'
Setting['mailer_from_address'] = 'noreply@consul.dev'

Setting['verification_offices_url'] = 'http://www.madrid.es/portales/munimadrid/es/Inicio/El-Ayuntamiento/Atencion-al-ciudadano/Oficinas-de-Atencion-al-Ciudadano?vgnextfmt=default&vgnextchannel=5b99cde2e09a4310VgnVCM1000000b205a0aRCRD'
Setting['min_age_to_participate'] = 16
Setting['min_age_to_verify'] = 16

Setting['featured_proposals_number'] = 3

Setting['proposal_improvement_path'] = nil

Setting['map_latitude'] = 40.4332002
Setting['map_longitude'] = -3.7009591
Setting['map_zoom'] = 10

Setting['related_content_score_threshold'] = -0.3

Setting["feature.user.skip_verification"] = 'true'

Setting['feature.homepage.widgets.feeds.proposals'] = true
Setting['feature.homepage.widgets.feeds.debates'] = true
Setting['feature.homepage.widgets.feeds.processes'] = true

