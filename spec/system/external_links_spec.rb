require "rails_helper"

describe "Warning for external links", :js do
  context "when the feature is enabled" do
    before { Setting["feature.gdpr.warning_for_external_links"] = true }

    scenario "warns before leaving to an external website" do
      visit root_path

      accept_confirm(I18n.t("shared.warning_for_external_links")) do
        click_link "open-source software"
      end

      expect(page).to have_current_path "http://www.gnu.org/licenses/agpl-3.0.html", url: true
    end

    scenario "cancels navigation when the user dismisses the confirm dialog" do
      visit root_path

      dismiss_confirm do
        click_link "open-source software"
      end

      expect(page).to have_current_path root_path
    end

    scenario "does not warn for mailto links", :admin do
      visit admin_root_path

      click_link "info@consulfoundation.org" # TODO: this opens mail applications in development

      expect(page).to have_current_path admin_root_path
    end

    scenario "does not warn when using the CKEditor link button", :admin do
      visit new_admin_site_customization_page_path
      fill_in_ckeditor "Content", with: "Filling in to make sure CKEditor is loaded"

      find(".cke_button__link").click

      expect(page).to have_css ".cke_dialog"
      expect(page).to have_current_path new_admin_site_customization_page_path
    end
  end

  scenario "does not warn when the feature is disabled" do
    Setting["feature.gdpr.warning_for_external_links"] = nil

    visit root_path

    click_link "open-source software"

    expect(page).to have_current_path "http://www.gnu.org/licenses/agpl-3.0.html", url: true
  end
end
