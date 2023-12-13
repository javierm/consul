class Admin::Settings::ConfigurationSettingsTabComponent < ApplicationComponent
  def settings
    non_configuration_prefixes = %w[feature homepage html machine_learning map process proposals
                                    remote_census sdg uploads]

    Setting.where.not("key LIKE ANY (array[?])", non_configuration_prefixes.map { |prefix| "#{prefix}.%" })
  end
end
