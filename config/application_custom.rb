module Consul
  class Application < Rails::Application
    config.autoload_paths.unshift(Rails.root.join('lib/custom'))
    config.i18n.default_locale = :es
    config.i18n.available_locales = ["es"]
  end
end
