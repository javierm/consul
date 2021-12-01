require "rails_helper"

describe Moderation::UsersController do
  before { sign_in create(:moderator).user }
  let(:user) { create(:user, email: "user@consul.dev") }

  describe "PUT hide" do
    it "keeps query parameters while using protected redirects" do
      get :hide, params: { id: user, search: "user@consul.dev", host: "evil.dev" }

      expect(response).to redirect_to "/moderation/users?search=user%40consul.dev"
    end

    it "redirects to the index of the section where it was called with a notice" do
      proposal = create(:proposal, author: user)
      request.env["HTTP_REFERER"] = proposal_path(proposal)

      put :hide, params: { id: user }

      expect(response).to redirect_to proposals_path
      expect(flash[:notice]).to eq "User blocked. All of this user's debates and comments have been hidden."
    end

    it "redirects to the index with a nested resource" do
      investment = create(:budget_investment, author: user)
      request.env["HTTP_REFERER"] = budget_investment_path(investment.budget, investment)

      put :hide, params: { id: user }

      expect(response).to redirect_to budget_investments_path(investment.budget)
    end
  end
end
