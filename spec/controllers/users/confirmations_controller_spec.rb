require "rails_helper"

describe Users::ConfirmationsController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
  end

  describe "GET show" do
    it "returns a 404 code with a wrong token" do
      expect { get :show, params: { token: "non_existent" } }.to raise_error ActiveRecord::RecordNotFound
    end

    it "redirect to sign_in page with a existent token " do
      user = create(:user, confirmation_token: "token1")

      get :show, params: { user: user, confirmation_token: "token1" }

      expect(flash[:notice]).to eq "You have already been verified; please attempt to sign in."
    end
  end
end
