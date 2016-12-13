require_dependency Rails.root.join('app', 'controllers', 'welcome_controller').to_s

class WelcomeController
  include CommentableActions

  def index
    if current_user
      redirect_to :proposals
    end

    @proposals = Proposal.all.not_archived.sort_by_confidence_score
    @proposals = @proposals.page(1).limit(3).for_render
    set_proposal_votes(@proposals)

    @debates = Debate.all.sort_by_confidence_score
    @debates = @debates.page(1).limit(3).for_render
    set_debate_votes(@debates)
  end

end
