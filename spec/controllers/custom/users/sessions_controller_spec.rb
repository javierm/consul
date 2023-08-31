require "rails_helper"

describe Users::SessionsController do
  before do
    request.env["devise.mapping"] = Devise.mappings[:user]
    allow(User).to receive(:maximum_attempts).and_return(1)
  end

  let!(:user) { create(:user, email: "citizen@consul.org", password: "12345678", locale: :es) }

  describe "Activity log" do
    context "when login process is successful" do
      it "tracks the login result" do
        expect do
          post :create, params: { user: { login: "citizen@consul.org", password: "12345678" }}
        end.to change(ActivityLog, :count).by(1)
        activity_log = ActivityLog.last
        expect(activity_log.activity).to eq("login")
        expect(activity_log.result).to eq("ok")
      end
    end

    context "when login process returns an error" do
      it "tracks the login error" do
        allow(User).to receive(:maximum_attempts).and_return(2)
        expect do
          post :create, params: { user: { login: "citizen@consul.org", password: "wrong" }}
        end.to change(ActivityLog, :count).by(1)
        activity_log = ActivityLog.last
        expect(activity_log.activity).to eq("login")
        expect(activity_log.result).to eq("error")
      end

      it "tracks the user account lock" do
        expect do
          post :create, params: { user: { login: "citizen@consul.org", password: "wrong" }}
        end.to change(ActivityLog, :count).by(2)
        activity_log = ActivityLog.first
        expect(activity_log.activity).to eq("login")
        expect(activity_log.result).to eq("error")
        activity_log = ActivityLog.last
        expect(activity_log.activity).to eq("login")
        expect(activity_log.result).to eq("blocked")
      end
    end
  end

  describe "Devise lock" do
    context "when devise sign in maximum_attempts reached", :with_frozen_time do
      it "locks the user account and sends an email to the account with an unlock link" do
        expect do
          post :create, params: { user: { login: "citizen@consul.org", password: "wrongpassword" }}
        end.to change { user.reload.failed_attempts }.by(1)
          .and change { user.reload.locked_at }.from(nil).to(Time.current)

        expect(ActionMailer::Base.deliveries.count).to eq(1)
        body = ActionMailer::Base.deliveries.last.body
        expect(body).to have_content "Tu cuenta ha sido bloqueada"
        expect(body).to have_link "Desbloquear mi cuenta"
      end
    end
  end
end
