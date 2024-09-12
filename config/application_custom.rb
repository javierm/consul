require "ntlm/smtp"

module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es]
    config.time_zone = "Atlantic/Canary"

    # Set to true to enable database tables auditing
    config.auditing_enabled = Rails.application.secrets.auditing_enabled

    # TODO: Remove after upgrading to Consul Democracy 2.2.1 or later,
    # since that version already includes this code
    initializer :exclude_custom_locales_automatic_loading, before: :add_locales do
      paths.add "config/locales", glob: "**[^custom]*/*.{rb,yml}"
    end
  end
end
