class WelcomeController < ApplicationController
  include CommentableActions
  skip_authorization_check

  layout "devise", only: [:welcome, :verification]

  def index
    if current_user
      redirect_to :proposals
    end
    @proposals = Proposal.all.not_archived
    @proposals = @proposals.page(1).limit(2).for_render.send("sort_by_hot_score")
    set_proposal_votes(@proposals)

    @debates = Debate.all
    @debates = @debates.page(1).limit(2).for_render.send("sort_by_hot_score")
    set_debate_votes(@debates)
  end

  def welcome
  end

  def verification
    redirect_to verification_path if signed_in?
  end


end
