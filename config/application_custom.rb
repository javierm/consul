module Consul
  class Application < Rails::Application
    config.autoload_paths << "#{Rails.root}/app/models/custom/concerns"
    config.autoload_paths << "#{Rails.root}/app/controllers/custom/concerns"
  end
end
