require_dependency Rails.root.join('app', 'controllers', 'management', 'proposals_controller').to_s

class Management::ProposalsController
  def print
    @proposals = Proposal.send("sort_by_#{@current_order}").for_render.page(params[:page])
    set_proposal_votes(@proposal)
  end
end
