class Admin::Settings::ConfigurationSettingsTabComponent < ApplicationComponent
  def settings
    non_configuration_prefixes = %w[feature homepage html machine_learning map process proposals
                                    remote_census sdg uploads]

    Setting.where.not(id: Setting.with_any_prefix(non_configuration_prefixes))
  end
end
