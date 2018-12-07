section "Creating Settings" do
  Setting.reset_defaults

  Setting["proposal_notification_minimum_interval_in_days"] = 0
  Setting["email_domain_for_officials"] = 'madrid.es'

  Setting.create(key: 'votes_for_proposal_success', value: '100')
  Setting.create(key: 'twitter_handle', value: '@decidemadrid')
  Setting.create(key: 'twitter_hashtag', value: '#decidemadrid')
  Setting.create(key: 'facebook_handle', value: 'decidemadrid')
  Setting.create(key: 'youtube_handle', value: 'decidemadrid')
  Setting.create(key: 'telegram_handle', value: 'decidemadrid')
  Setting.create(key: 'instagram_handle', value: 'decidemadrid')
  Setting.create(key: 'url', value: 'http://localhost:3000')
  Setting.create(key: 'place_name', value: 'City')

  Setting.create(key: 'feature.spending_proposal_features.phase3', value: "true")
  Setting.create(key: 'feature.probe.plaza', value: 'true')
  Setting.create(key: 'feature.human_rights.accepting', value: 'true')
  Setting.create(key: 'feature.human_rights.voting', value: 'true')
  Setting.create(key: 'feature.human_rights.closed', value: 'true')
  Setting.create(key: 'feature.map', value: "true")
  Setting.create(key: 'feature.guides', value: true)

  Setting.create(key: 'mailer_from_name', value: 'Decide Madrid')
  Setting.create(key: 'mailer_from_address', value: 'noreply@madrid.es')
  Setting.create(key: 'meta_title', value: 'Decide Madrid')
  Setting.create(key: 'meta_description', value: 'Citizen Participation & Open Gov Application')
  Setting.create(key: 'meta_keywords', value: 'citizen participation, open government')

  Setting.create(key: 'verification_offices_url', value: 'http://oficinas-atencion-ciudadano.url/')
  Setting.create(key: 'min_age_to_participate', value: '16')
  Setting.create(key: 'analytics_url', value: "")

end
