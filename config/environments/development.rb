require 'logstash-logger'

Rails.application.configure do
  # Settings specified here will take precedence over those in config/application.rb.

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Do not eager load code on boot.
  config.eager_load = false

  # Show full error reports and disable caching.
  config.consider_all_requests_local = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send.
  config.action_mailer.raise_delivery_errors = false
  config.action_mailer.default_url_options = {host: 'localhost', port: 3000}
  config.action_mailer.asset_host = "http://localhost:3000"

  # Deliver emails to a development mailbox at /letter_opener
  config.action_mailer.delivery_method = :letter_opener

  # Print deprecation notices to the Rails logger.
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations.
  config.active_record.migration_error = :page_load

  # Debug mode disables concatenation and preprocessing of assets.
  # This option may cause significant delays in view rendering with a large
  # number of complex assets.
  config.assets.debug = true

  config.force_ssl = false
  config.ssl_options = {hsts: { expires: 0 }}


  # Asset digests allow you to set far-future HTTP expiration dates on all assets,
  # yet still be able to expire them through the digest params.
  config.assets.digest = true


  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  config.web_console.whitelisted_ips = '172.23.0.1'

  # Raises error for missing translations
  # config.action_view.raise_on_missing_translations = true

=begin
  config.logger = LogStashLogger::MultiLogger.new(
    [
      EdoLogger.new(STDOUT),
      #LogStashLogger.new(type: :tcp, host: 'localhost', port: 5044, formatter: EdoFormatter)
    ]
  )
=end

  # Debug level prints a lot of stuff
  config.log_level = :debug

  config.cache_store = :dalli_store

  config.relative_url_root = ENV['CONSUL_RELATIVE_URL'].nil? || ENV['CONSUL_RELATIVE_URL'].empty? ? '/' : ENV['CONSUL_RELATIVE_URL']

  config.after_initialize do
    Bullet.enable = true
    Bullet.bullet_logger = true
    if ENV['BULLET']
      Bullet.rails_logger = true
      Bullet.add_footer = true
    end
  end
end
