class Admin::Settings::ProposalsDashboardComponent < ApplicationComponent
  attr_reader :settings

  def initialize(settings)
    @settings = settings
  end
end
