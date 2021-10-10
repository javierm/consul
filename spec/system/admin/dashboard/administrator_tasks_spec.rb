require "rails_helper"

describe "Admin administrator tasks", :admin do
  describe "Index" do
    scenario "shows that there are no records available with no pending tasks" do
      visit admin_dashboard_administrator_tasks_path

      expect(page).to have_content "There are no resources requested"
    end

    scenario "shows the task data and a link that allows solving the request with actions defined" do
      task = create(:dashboard_administrator_task, :pending)

      visit admin_dashboard_administrator_tasks_path

      expect(page).to have_content task.source.proposal.title
      expect(page).to have_content task.source.action.title
      expect(page).to have_link "Solve"
    end

    scenario "After solving a task it appears in the solved filter" do
      task = create(:dashboard_administrator_task, :pending)

      visit admin_dashboard_administrator_tasks_path
      click_link "Solve"

      expect(page).to have_link task.source.proposal.title
      expect(page).to have_content task.source.action.title

      click_button "Mark as solved"

      expect(page).not_to have_link task.source.proposal.title
      expect(page).not_to have_content task.source.action.title
      expect(page).to have_content "The task has been marked as solved"

      within("#filter-subnav") do
        click_link "Solved"
      end

      expect(page).to have_content task.source.proposal.title
      expect(page).to have_content task.source.action.title
      expect(page).not_to have_link "Solve"
    end
  end
end
