class Admin::Settings::ProposalsDashboardComponent < ApplicationComponent
  def settings
    Setting.with_prefix("proposals")
  end
end
