require "ntlm/smtp"

module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es]
    config.time_zone = "Atlantic/Canary"

    # Set to true to enable database tables auditing
    config.auditing_enabled = Rails.application.secrets.auditing_enabled
    config.devise_lockable = Rails.application.secrets.devise_lockable
  end
end
