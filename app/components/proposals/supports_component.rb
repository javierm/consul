class Proposals::SupportsComponent < ApplicationComponent
  attr_reader :proposal

  def initialize(proposal)
    @proposal = proposal
  end

  private

    def progress_bar_percentage
      percentage.floor
    end

    def supports_percentage
      number_to_percentage(percentage, strip_insignificant_zeros: true, precision: 1)
    end

    def percentage
      [
        proposal.total_votes.to_f * 100 / Proposal.votes_needed_for_success,
        100
      ].min
    end
end
