require "rails_helper"

describe "Voter" do
  context "Origin", :with_frozen_time do
    let(:poll) { create(:poll, :current) }
    let(:question) { create(:poll_question, poll: poll) }
    let(:booth) { create(:poll_booth) }
    let(:officer) { create(:poll_officer) }
    let(:admin) { create(:administrator) }
    let!(:answer_yes) { create(:poll_question_answer, question: question, title: "Yes") }

    before do
      create(:geozone, :in_census)
      create(:poll_shift, officer: officer, booth: booth, date: Date.current, task: :vote_collection)
      create(:poll_officer_assignment, officer: officer, poll: poll, booth: booth)
    end

    scenario "Voting via web - Standard" do
      user = create(:user, :level_two)

      login_as user
      visit poll_path(poll)

      choose answer_yes.title
      click_button "Send"

      expect(page).to have_content("Poll saved successfully!")
      expect(Poll::Voter.count).to eq(1)
      expect(Poll::Voter.first.origin).to eq("web")
    end

    scenario "Voting via web as unverified user" do
      user = create(:user, :incomplete_verification)

      login_as user
      visit poll_path(poll)

      expect(page).to have_content("You must verify your account in order to answer")
      expect(page).not_to have_content("You have already participated in this poll. If you vote again it will be overwritten")
    end

    scenario "Voting in poll and then verifiying account" do
      user = create(:user)

      login_through_form_as_officer(officer.user)
      vote_for_poll_via_booth

      visit root_path
      click_link "Sign out"

      login_as user
      visit account_path
      click_link "Verify my account"

      verify_residence
      confirm_phone(user)

      visit poll_path(poll)

      expect(page).to have_content "You have already participated in a physical booth. You can not participate again."
      expect(Poll::Voter.count).to eq(1)

      visit root_path
      click_link "Sign out"
      login_as(admin.user)
      visit admin_poll_recounts_path(poll)

      within("#total_system") do
        expect(page).to have_content "1"
      end

      within "tr", text: booth.name do
        expect(page).to have_content "1"
      end
    end
  end
end
