require "rails_helper"

describe "Admin menu", :admin do
  scenario "when the audit feature is enabled it shows the link in the navigation" do
    allow(Rails.application.config).to receive(:auditing_enabled).and_return(true)

    visit admin_root_path

    within "#admin_menu" do
      expect(page).to have_link "Changelog", href: admin_audits_path
    end
  end

  scenario "when the audit feature is disabled it does not show the link" do
    allow(Rails.application.config).to receive(:auditing_enabled).and_return(false)

    visit admin_root_path

    within "#admin_menu" do
      expect(page).not_to have_link "Changelog"
    end
  end

  scenario "it does not show the audited link for the main tenant when it is in management mode" do
    allow(Rails.application.config).to receive_messages(auditing_enabled: true,
                                                        multitenancy_management_mode: true)

    visit admin_root_path

    within "#admin_menu" do
      expect(page).not_to have_link "Changelog"
    end
  end
end
