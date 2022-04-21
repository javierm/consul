require "rails_helper"

describe "Valuation" do
  context "Access" do
    scenario "Access as a valuator is authorized" do
      create(:budget)
      login_as(create(:valuator).user)

      visit root_path
      click_link "Menu"
      click_link "Valuation"

      expect(page).to have_current_path(valuation_root_path)
      expect(page).not_to have_content "You do not have permission to access this page"
    end

    scenario "Access as an administrator is authorized" do
      create(:budget)
      login_as(create(:administrator).user)

      visit root_path
      click_link "Menu"
      click_link "Valuation"

      expect(page).to have_current_path(valuation_root_path)
      expect(page).not_to have_content "You do not have permission to access this page"
    end

    scenario "Access as regular user is not authorized" do
      login_as(create(:user))
      visit root_path

      expect(page).not_to have_link "Menu"
      expect(page).not_to have_link "Valuation"

      visit valuation_root_path

      expect(page).not_to have_current_path(valuation_root_path)
      expect(page).to have_current_path(root_path)
      expect(page).to have_content "You do not have permission to access this page"
    end

    scenario "Access as other roles is not authorized" do
      unauthorized = [
        create(:moderator).user,
        create(:manager).user,
        create(:sdg_manager).user,
        create(:poll_officer).user
      ]

      unauthorized.each do |user|
        login_as(user)

        visit root_path
        click_link "Menu"

        expect(page).not_to have_link "Valuation"

        visit valuation_root_path

        expect(page).not_to have_current_path(valuation_root_path)
        expect(page).to have_current_path(root_path)
        expect(page).to have_content "You do not have permission to access this page"
      end
    end
  end

  scenario "Valuation access links" do
    create(:budget)
    login_as(create(:valuator).user)

    visit root_path
    click_link "Menu"

    expect(page).to have_link("Valuation")
    expect(page).not_to have_link("Administration")
    expect(page).not_to have_link("Moderation")
  end

  scenario "Valuation dashboard" do
    create(:budget)

    login_as(create(:valuator).user)
    visit root_path

    click_link "Menu"
    click_link "Valuation"

    expect(page).to have_current_path(valuation_root_path)
    expect(page).to have_css("#valuation_menu")
    expect(page).not_to have_css("#admin_menu")
    expect(page).not_to have_css("#moderation_menu")
  end
end
