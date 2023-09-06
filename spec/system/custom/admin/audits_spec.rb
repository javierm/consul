require "rails_helper"

describe "Audits" do
  let(:administrator) { create(:administrator, user: create(:user, username: "Ana")) }

  before do
    allow(Rails.application.config).to receive(:auditing_enabled).and_return(true)
    proposal = create(:proposal, title: "Initial proposal title")
    debate = create(:debate, title: "Initial debate title")
    proposal.update!(title: "Updated proposal title")
    debate.update!(title: "Updated debate title")
    login_as administrator.user
  end

  context "Investments Participatory Budgets" do
    scenario "Changes" do
      investment = create(:budget_investment, title: "Good old times")

      visit admin_budget_budget_investment_path(investment.budget, investment)

      expect(page).not_to have_content "There are no changes logged"

      click_link "Edit"
      fill_in "Title", with: "Modern times"
      click_button "Update"

      expect(page).not_to have_content "There are no changes logged"
      expect(page).to have_content "Change Log"

      within("#audits thead") do
        expect(page).to have_content "Field"
        expect(page).to have_content "Old Value"
        expect(page).to have_content "New Value"
        expect(page).to have_content "Edited at"
        expect(page).to have_content "Edited by"
      end

      within("#audits tbody") do
        expect(page).to have_content "Title"
        expect(page).to have_content "Good old times"
        expect(page).to have_content "Modern times"
        expect(page).to have_content "Ana"
      end
    end
  end

  describe "index" do
    scenario "redirects to admin root path when audit is disablef" do
      allow(Rails.application.config).to receive(:auditing_enabled).and_return(false)

      visit admin_audits_path

      expect(page).to have_content("The change log feature is disabled.")
      expect(page).to have_content("Ask your system administrator to enable it via the secrets file.")
      expect(page).to have_current_path(admin_root_path)
    end

    scenario "show latest audits records first" do
      visit admin_audits_path

      expect("Proposal").to appear_before("Debate")
    end

    scenario "shows pagination links" do
      allow(Audit).to receive(:default_per_page).and_return(1)

      visit admin_audits_path

      within "ul.pagination" do
        expect(page).to have_link("2", href: admin_audits_path(page: 2))
      end
    end

    scenario "filters records by given associated or auditable class name and ID pair" do
      proposal = create(:proposal)
      proposal.update!(title: "New proposal title")
      debate = create(:debate)
      debate.update!(title: "New debate title")

      visit admin_audits_path

      expect(page).to have_content("New proposal title")
      expect(page).to have_content("New debate title")

      visit admin_audits_path(search: "Debate##{debate.id}")

      expect(page).not_to have_content("New proposal title")
      expect(page).to have_content("New debate title")

      visit admin_audits_path(search: "Debate::Translation##{debate.translation.id}")

      expect(page).not_to have_content("New proposal title")
      expect(page).to have_content("New debate title")
    end
  end
end
