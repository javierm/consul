require 'rails_helper'

feature "Home" do

  feature "For not logged users" do
    scenario 'Welcome message' do
    end
    scenario 'Lists proposals and debates with most confidence' do
      proposals = [create(:proposal), create(:proposal), create(:proposal)]
      debates = [create(:debate), create(:debate), create(:debate)]

      visit root_path

      expect(page).to have_selector('#proposals-list .proposal', count: 2)
      proposals[0..1].each do |proposal|
        within('#proposals-list') do
          expect(page).to have_content proposal.title
          expect(page).to have_css("a[href='#{proposal_path(proposal)}']", text: proposal.title)
          expect(page).to have_css("a[href='#{proposal_path(proposal)}']", text: proposal.summary)
        end
      end

      expect(page).to have_selector('#debates-list .debate', count: 2)
      debates[0..1].each do |debate|
        within('#debates-list') do
          expect(page).to have_content debate.title
          expect(page).to have_css("a[href='#{debate_path(debate)}']", text: debate.title)
          expect(page).to have_css("a[href='#{debate_path(debate)}']", text: debate.description)
        end
      end
    end
  end

  feature "For signed in users" do
    scenario 'Redirect to proposals' do
      login_as(create(:user))
      visit root_path

      expect(current_path).to eq proposals_path
    end
  end

  feature 'IE alert' do
    scenario 'IE visitors are presented with an alert until they close it', :js do
      page.driver.headers = { "User-Agent" => "Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 6.0)" }

      visit root_path
      expect(page).to have_xpath(ie_alert_box_xpath, visible: false)
      expect(page.driver.cookies['ie_alert_closed']).to be_nil

      # faking close button, since a normal find and click
      # will not work as the element is inside a HTML conditional comment
      page.driver.set_cookie 'ie_alert_closed', 'true'

      visit root_path
      expect(page).not_to have_xpath(ie_alert_box_xpath, visible: false)
      expect(page.driver.cookies["ie_alert_closed"].value).to eq('true')
    end

    scenario 'non-IE visitors are not bothered with IE alerts', :js do
      visit root_path
      expect(page).not_to have_xpath(ie_alert_box_xpath, visible: false)
      expect(page.driver.cookies['ie_alert_closed']).to be_nil
    end

    def ie_alert_box_xpath
      "/html/body/div[@class='wrapper']/comment()[contains(.,'ie-callout')]"
    end
  end
end
