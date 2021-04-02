require "rails_helper"

describe "Admin banners magement", :admin do
  context "Index" do
    before do
      create(:banner, title: "Banner number one",
             description:  "This is the text of banner number one and is not active yet",
             target_url:  "http://www.url.com",
             post_started_at: (Time.current + 4.days),
             post_ended_at:   (Time.current + 10.days),
             background_color: "#FF0000",
             font_color: "#FFFFFF")

      create(:banner, title: "Banner number two",
             description:  "This is the text of banner number two and is not longer active",
             target_url:  "http://www.url.com",
             post_started_at: (Time.current - 10.days),
             post_ended_at:   (Time.current - 3.days),
             background_color: "#00FF00",
             font_color: "#FFFFFF")

      create(:banner, title: "Banner number three",
             description:  "This is the text of banner number three",
             target_url:  "http://www.url.com",
             post_started_at: (Time.current - 1.day),
             post_ended_at:   (Time.current + 10.days),
             background_color: "#0000FF",
             font_color: "#FFFFFF")

      create(:banner, title: "Banner number four",
             description:  "This is the text of banner number four",
             target_url:  "http://www.url.com",
             post_started_at: (DateTime.current - 10.days),
             post_ended_at:   (DateTime.current + 10.days),
             background_color: "#FFF000",
             font_color: "#FFFFFF")

      create(:banner, title: "Banner number five",
             description:  "This is the text of banner number five",
             target_url:  "http://www.url.com",
             post_started_at: (DateTime.current - 10.days),
             post_ended_at:   (DateTime.current + 10.days),
             background_color: "#FFFF00",
             font_color: "#FFFFFF")
    end

    scenario "Index show active banners" do
      visit admin_banners_path(filter: "with_active")
      expect(page).to have_content("There are 4 banners")
    end

    scenario "Index show inactive banners" do
      visit admin_banners_path(filter: "with_inactive")
      expect(page).to have_content("There are 2 banners")
    end

    scenario "Index show all banners" do
      visit admin_banners_path
      expect(page).to have_content("There are 9 banners")
    end
  end
end
