section "Creating Settings" do
  Setting.reset_defaults

  {
    "proposal_notification_minimum_interval_in_days":  0,
    "email_domain_for_officials":                      'madrid.es',
    "votes_for_proposal_success":                      '100',
    "twitter_handle":                                  '@decidemadrid',
    "twitter_hashtag":                                 '#decidemadrid',
    "facebook_handle":                                 'decidemadrid',
    "youtube_handle":                                  'decidemadrid',
    "telegram_handle":                                 'decidemadrid',
    "instagram_handle":                                'decidemadrid',
    "url":                                             'http://localhost:3000',
    "place_name":                                      'City',
    "feature.spending_proposal_features.phase3":       "true",
    "feature.probe.plaza":                             'true',
    "feature.human_rights.accepting":                  'true',
    "feature.human_rights.voting":                     'true',
    "feature.human_rights.closed":                     'true',
    "feature.map":                                     "true",
    "feature.guides":                                  true,
    "mailer_from_name":                                'Decide Madrid',
    "mailer_from_address":                             'noreply@madrid.es',
    "meta_title":                                      'Decide Madrid',
    "meta_description":                                'Citizen Participation & Open Gov Application',
    "meta_keywords":                                   'citizen participation, open government',
    "verification_offices_url":                        'http://oficinas-atencion-ciudadano.url/',
    "min_age_to_participate":                          '16',
    "analytics_url":                                   ""
  }.each do |name, value|
    Setting[name] = value
  end
end
