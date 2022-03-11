require "rails_helper"

describe Verification::SmsController do
  describe "GET edit" do
    it "redirects to the account path" do
      sign_in create(:user)

      get :edit

      expect(response).to redirect_to account_path
    end
  end

  describe "PUT update" do
    it "redirects to the account path" do
      sign_in create(:user)

      put :update

      expect(response).to redirect_to account_path
    end
  end
end
