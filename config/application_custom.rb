module Consul
  class Application < Rails::Application
    config.autoload_paths << "#{Rails.root}/app/models/custom/concerns"
    config.autoload_paths << "#{Rails.root}/app/controllers/custom/concerns"
    config.autoload_paths << "#{Rails.root}/app/mailers/custom"
    config.autoload_paths.unshift(Rails.root.join('lib/custom'))
  end
end
