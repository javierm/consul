class Proposals::VotesComponent < ApplicationComponent
  attr_reader :proposal, :featured
  alias_method :featured?, :featured
  delegate :current_user, :link_to_verify_account, :user_signed_in?, to: :helpers

  def initialize(proposal, vote_url: nil, featured: false)
    @proposal = proposal
    @vote_url = vote_url
    @featured = featured
  end

  def vote_url
    @vote_url || vote_proposal_path(proposal, value: "yes")
  end
end
