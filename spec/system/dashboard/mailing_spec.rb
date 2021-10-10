require "rails_helper"

describe "Mailing" do
  let!(:proposal) { create(:proposal, :draft) }

  before do
    login_as(proposal.author)
    visit new_proposal_dashboard_mailing_path(proposal)
  end

  scenario "User receives feedback after the email is sent" do
    click_link "Send to #{proposal.author.email}"
    expect(page).to have_content("The email has been sent")
  end

  scenario "Preview contains the proposal title and the link to send the email" do
    click_link "Preview"

    expect(page).not_to have_link "Preview"
    expect(page).to have_content proposal.title
    expect(page).to have_link "Send to #{proposal.author.email}"
  end
end
