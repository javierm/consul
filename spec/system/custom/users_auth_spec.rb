require "rails_helper"

describe "Users" do
  context "Regular authentication with password complexity enabled" do
    before do
      allow(Rails.application).to receive(:secrets).and_return(ActiveSupport::OrderedOptions.new.merge(
        security: { password_complexity: true }
      ))
    end

    context "Sign up" do
      scenario "Success with password" do
        message = "You have been sent a message containing a verification link. Please click on this link to activate your account."
        visit "/"
        click_link "Register"

        fill_in "Username", with: "Manuela Carmena"
        fill_in "Email", with: "manuela@consul.dev"
        fill_in "Password", with: "ValidPassword1234"
        fill_in "Confirm password", with: "ValidPassword1234"
        check "user_terms_of_service"

        click_button "Register"

        expect(page).to have_content message

        confirm_email

        expect(page).to have_content "Your account has been confirmed."
      end

      scenario "Errors on sign up" do
        visit "/"
        click_link "Register"

        fill_in "Username", with: "Manuela Carmena"
        fill_in "Email", with: "manuela@consul.dev"
        fill_in "Password", with: "invalid_password"
        fill_in "Confirm password", with: "invalid_password"
        check "user_terms_of_service"

        click_button "Register"

        expect(page).to have_content "must contain at least one digit, must contain at least one upper-case letter"
      end
    end
  end
end
