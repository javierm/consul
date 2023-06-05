require "ntlm/smtp"

module Consul
  class Application < Rails::Application
    config.devise_lockable = Rails.application.secrets.devise_lockable
    config.i18n.default_locale = :es
    config.i18n.available_locales = [:es]
  end
end
