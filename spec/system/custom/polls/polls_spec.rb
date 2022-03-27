require "rails_helper"

describe "Polls" do
  describe "Index" do
    scenario "Displays icon correctly", :consul do
      create_list(:poll, 3)

      visit polls_path

      expect(page).not_to have_css(".not-logged-in")
      expect(page).not_to have_content("You must sign in or sign up to participate")

      user = create(:user)
      login_as(user)

      visit polls_path

      expect(page).to have_css(".unverified", count: 3)
      expect(page).to have_content("You must verify your account to participate")
    end

    scenario "Already participated in a poll" do
      question = create(:poll_question, :yes_no)
      login_as(create(:user, :level_two))

      visit poll_path(question.poll)
      choose "Yes"
      click_button "Send"

      expect(page).to have_content("Poll saved successfully!")

      visit polls_path(question.poll)

      expect(page).to have_css(".already-answer", count: 1)
      expect(page).to have_content("You already have participated in this poll")
    end
  end

  context "Show" do
    let(:geozone) { create(:geozone) }
    let(:poll) { create(:poll) }

    scenario "Level 2 users who have already answered" do
      question = create(:poll_question, :yes_no, poll: poll)
      no = question.question_answers.last
      user = create(:user, :level_two)
      create(:poll_answer, question: question, author: user, answer: no)

      login_as user
      visit poll_path(poll)

      expect(page).to have_checked_field("No")
    end

    scenario "Question answers appear in the given order" do
      question = create(:poll_question, poll: poll)
      answer1 = create(:poll_question_answer, title: "First answer", question: question, given_order: 2)
      answer2 = create(:poll_question_answer, title: "Second answer", question: question, given_order: 1)

      visit poll_path(poll)

      expect(answer2.title).to appear_before(answer1.title)
    end

    scenario "Level 1 users" do
      visit polls_path
      expect(page).not_to have_selector(".already-answer")

      poll.update!(geozone_restricted: true)
      poll.geozones << geozone

      create(:poll_question, :yes_no, poll: poll)

      login_as(create(:user, geozone: geozone))
      visit poll_path(poll)

      expect(page).to have_content("You must verify your account in order to answer")

      expect(page).to have_field("Yes")
      expect(page).to have_field("No")
    end

    scenario "Level 2 users in an expired poll" do
      expired_poll = create(:poll, :expired, geozone_restricted: true)
      expired_poll.geozones << geozone

      create(:poll_question, :yes_no, poll: expired_poll)

      login_as(create(:user, :level_two, geozone: geozone))

      visit poll_path(expired_poll)

      expect(page).to have_field("Yes", disabled: true)
      expect(page).to have_field("No", disabled: true)
      expect(page).to have_content("This poll has finished")
    end

    scenario "Show form errors when any answer is invalid" do
      poll = create(:poll)
      open_question = create(:poll_question, poll: poll, mandatory_answer: true)
      single_choice_question = create(:poll_question, :yes_no, poll: poll, mandatory_answer: true)
      login_as(create(:user, :verified))

      visit poll_path(poll)
      click_button "Send"

      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_content("can't be blank")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_content("Answer can't be blank")
      end
    end

    scenario "Show fullfilled form when answers were saved successfully" do
      Setting["feature.user.skip_verification"] = true
      poll = create(:poll)
      open_question = create(:poll_question, poll: poll)
      single_choice_question = create(:poll_question, :yes_no, poll: poll)
      login_as(create(:user))

      visit poll_path(poll)
      fill_in open_question.title, with: "Open answer to question 1"
      choose "Yes"
      click_button "Send"

      expect(page).to have_content("You have already participated in this poll.")
      expect(page).to have_content("If you vote again it will be overwritten.")

      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_field(open_question.title, with: "Open answer to question 1")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_field("Yes", checked: true)
        expect(page).to have_field("No", checked: false)
      end
    end

    scenario "Allow to update answers" do
      Setting["feature.user.skip_verification"] = true
      poll = create(:poll)
      user = create(:user)
      open_question = create(:poll_question, poll: poll)
      single_choice_question = create(:poll_question, :yes_no, poll: poll)
      yes = single_choice_question.question_answers.first
      create(:poll_answer, question: open_question, open_answer: "Open answer", author: user)
      create(:poll_answer, question: single_choice_question, answer: yes, author: user)
      create(:poll_voter, user: user, poll: poll)
      login_as(user)

      visit poll_path(poll)

      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_field(open_question.title, with: "Open answer")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_field("Yes", checked: true)
        expect(page).to have_field("No", checked: false)
      end

      fill_in open_question.title, with: "Open answer update"
      choose "No"
      click_button "Send"

      expect(page).to have_content("Poll saved successfully!")

      within "#question_#{open_question.id}_answer_fields" do
        expect(page).to have_field(open_question.title, with: "Open answer update")
      end
      within "#question_#{single_choice_question.id}_answer_fields" do
        expect(page).to have_field("Yes", checked: false)
        expect(page).to have_field("No", checked: true)
      end
    end

    scenario "Guest users can answer the poll questions" do
      Setting["feature.user.skip_verification"] = true
      create(:poll_question, :yes_no, poll: poll)

      visit poll_path(poll)

      choose "Yes"
      click_button "Send"

      expect(page).to have_content("Poll saved successfully!")
      expect(page).to have_field("Yes", checked: true)
      expect(page).to have_field("No", checked: false)

      choose "No"
      click_button "Send"

      expect(page).to have_content("Poll saved successfully!")
      expect(page).to have_field("Yes", checked: false)
      expect(page).to have_field("No", checked: true)
    end
  end
end
