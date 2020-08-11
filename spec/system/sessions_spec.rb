require "rails_helper"

describe "Sessions" do
  scenario "Staying in the same page after doing login/logout" do
    user = create(:user, sign_in_count: 10)
    debate = create(:debate)

    visit debate_path(debate)
    click_link "Sign in"
    fill_in "user_login", with: user.email
    fill_in "user_password", with: user.password
    click_button "Enter"

    expect(page).to have_content("You have been signed in successfully")
    expect(page).to have_current_path(debate_path(debate))

    click_link "Sign out"

    expect(page).to have_content("You have been signed out successfully")
    expect(page).to have_current_path(debate_path(debate))
  end

  scenario "Sign in redirects to the homepage if the user was there" do
    user = create(:user, :level_two)

    visit debates_path
    visit "/"
    click_link "Sign in"
    fill_in "user_login", with: user.email
    fill_in "user_password", with: user.password
    click_button "Enter"

    expect(page).to have_current_path "/"
  end
end
