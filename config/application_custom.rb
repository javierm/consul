require "ntlm/smtp"

module Consul
  class Application < Rails::Application
    # Set to true to enable database tables auditing
    config.auditing_enabled = Rails.application.secrets.auditing_enabled
    config.i18n.default_locale = :es
    config.i18n.available_locales = ["es"]
    config.time_zone = "Atlantic/Canary"

    config.autoload_paths << "#{Rails.root}/app/controllers/custom/concerns"

    # TODO: Remove after upgrading to Consul Democracy 2.2.1 or later,
    # since that version already includes this code
    initializer :exclude_custom_locales_automatic_loading, before: :add_locales do
      paths.add "config/locales", glob: "**[^custom]*/*.{rb,yml}"
    end
  end
end
