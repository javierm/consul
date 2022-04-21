require "rails_helper"

describe "Moderation" do
  scenario "Access as a moderator is authorized" do
    login_as(create(:moderator).user)
    visit root_path
    click_link "Menu"
    click_link "Moderation"

    expect(page).to have_current_path(moderation_root_path)
    expect(page).not_to have_content "You do not have permission to access this page"
  end

  scenario "Access as an administrator is authorized" do
    login_as(create(:administrator).user)
    visit root_path
    click_link "Menu"
    click_link "Moderation"

    expect(page).to have_current_path(moderation_root_path)
    expect(page).not_to have_content "You do not have permission to access this page"
  end

  scenario "Access as regular user is not authorized" do
    login_as(create(:user))

    visit root_path

    expect(page).not_to have_link "Menu"
    expect(page).not_to have_link "Moderation"

    visit moderation_root_path

    expect(page).not_to have_current_path(moderation_root_path)
    expect(page).to have_current_path(root_path)
    expect(page).to have_content "You do not have permission to access this page"
  end

  scenario "Access as other roles is not authorized" do
    unauthorized = [
      create(:valuator).user,
      create(:manager).user,
      create(:sdg_manager).user,
      create(:poll_officer).user
    ]

    unauthorized.each do |user|
      login_as(user)

      visit root_path
      click_link "Menu"

      expect(page).not_to have_link "Moderation"

      visit moderation_root_path

      expect(page).not_to have_current_path(moderation_root_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to access this page"
    end
  end

  scenario "Moderation access links" do
    login_as(create(:moderator).user)

    visit root_path
    click_link "Menu"

    expect(page).to have_link("Moderation")
    expect(page).not_to have_link("Administration")
    expect(page).not_to have_link("Valuation")
  end

  context "Moderation dashboard" do
    before do
      Setting["org_name"] = "OrgName"
    end

    scenario "Contains correct elements" do
      login_as(create(:moderator).user)

      visit root_path
      click_link "Menu"
      click_link "Moderation"

      expect(page).to have_link("Go back to OrgName")
      expect(page).to have_current_path(moderation_root_path)
      expect(page).to have_css("#moderation_menu")
      expect(page).not_to have_css("#admin_menu")
      expect(page).not_to have_css("#valuation_menu")
    end
  end
end
