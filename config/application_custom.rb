module Consul
  class Application < Rails::Application
    config.i18n.default_locale = :val
    available_locales = [
      "val",
      "es"]
    config.i18n.available_locales = available_locales
  end
end
