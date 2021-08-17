require "rails_helper"

describe Admin::ActionComponent do
  it "includes an HTML class for the action" do
    render_inline Admin::ActionComponent.new(:edit, double, path: "/")

    expect(page).to have_css "a.edit-link"
  end

  describe "aria-label attribute" do
    it "includes the action and the human_name of the record" do
      record = double(human_name: "Stay home")

      render_inline Admin::ActionComponent.new(:edit, record, path: "/")

      expect(page).to have_link count: 1
      expect(page).to have_css "a[aria-label='Edit Stay home']", exact_text: "Edit"
    end

    it "uses the to_s method when there's no human_name" do
      record = double(to_s: "do_not_go_out")

      render_inline Admin::ActionComponent.new(:edit, record, path: "/")

      expect(page).to have_link count: 1
      expect(page).to have_css "a[aria-label='Edit Do not go out']", exact_text: "Edit"
    end

    it "uses the human_name when there are both human_name and to_s" do
      record = double(human_name: "Stay home", to_s: "do_not_go_out")

      render_inline Admin::ActionComponent.new(:edit, record, path: "/")

      expect(page).to have_link count: 1
      expect(page).to have_css "a[aria-label='Edit Stay home']", exact_text: "Edit"
    end
  end
end
