ENV["RAILS_ENV"] ||= "test"
if ENV["COVERALLS_REPO_TOKEN"]
  require "coveralls"
  Coveralls.wear!("rails")
end
require File.expand_path("../../config/environment", __FILE__)
abort("The Rails environment is running in production mode!") if Rails.env.production?

require "rspec/rails"
require "spec_helper"
require "capybara/rails"
require "capybara/rspec"
require "selenium/webdriver"
require "view_component/test_helpers"

module ViewComponent
  module TestHelpers
    def sign_in(user)
      allow(controller).to receive(:current_user).and_return(user)
    end
  end
end

RSpec.configure do |config|
  config.include ViewComponent::TestHelpers, type: :component
end

Rails.application.load_tasks if Rake::Task.tasks.empty?

include Warden::Test::Helpers
Warden.test_mode!

ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!
  config.after do
    Warden.test_reset!
  end
end

FactoryBot.use_parent_strategy = false

require "capybara/cuprite"

# Then, we need to register our driver to be able to use it later
# with #driven_by method.
Capybara.register_driver(:cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [1200, 800],
    browser_options: {},
    # Increase Chrome startup wait time (required for stable CI builds)
    process_timeout: 10,
    headless: true
  )
end
# args: %W[headless no-sandbox window-size=1200,800 proxy-server=#{Capybara.app_host}:#{Capybara::Webmock.port_number}]

Capybara.exact = true
Capybara.enable_aria_label = true
Capybara.disable_animation = true

OmniAuth.config.test_mode = true
