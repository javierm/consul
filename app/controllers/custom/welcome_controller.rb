require_dependency Rails.root.join('app', 'controllers', 'welcome_controller').to_s

class WelcomeController
  include CommentableActions
  skip_before_action :ensure_signup_complete, only: [:closed]
  skip_before_action :set_locale, only: [:closed]
  skip_before_action :track_email_campaign, only: [:closed]
  skip_before_action :set_return_url, only: [:closed]

  def index
    # if current_user
    #   redirect_to :proposals
    # end

  end

  def resume
    @proposals = Proposal.all.not_archived.sort_by_confidence_score
    @proposals = @proposals.page(1).limit(3).for_render
    set_proposal_votes(@proposals)

    @debates = Debate.all.sort_by_confidence_score
    @debates = @debates.page(1).limit(3).for_render
    set_debate_votes(@debates)
  end

  def closed
    render layout: 'closed'
  end

end
