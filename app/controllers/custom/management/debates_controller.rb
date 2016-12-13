class Management::DebatesController < Management::BaseController
  include HasOrders

  has_orders %w{confidence_score hot_score created_at relevance}, only: :print

  def print
    @debates = Debate.send("sort_by_#{@current_order}").for_render.page(params[:page])
    set_debate_votes(@debate)
  end

  private

    def set_debate_votes(debates)
      @debate_votes = current_user ? current_user.debate_votes(debates) : {}
    end
end
