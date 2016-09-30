require_dependency Rails.root.join('app', 'controllers', 'welcome_controller').to_s

class WelcomeController
  include CommentableActions

  def index
    if current_user
      redirect_to :proposals
    end

    @proposals = Proposal.all.not_archived
    @proposals = @proposals.page(1).limit(2).for_render.send("sort_by_confidence_score")
    set_proposal_votes(@proposals)

    @debates = Debate.all
    @debates = @debates.page(1).limit(2).for_render.send("sort_by_confidence_score")
    set_debate_votes(@debates)
  end

end
