require "rails_helper"

describe Admin::TableActionComponent, type: :component do
  describe "aria-label attribute" do
    it "includes the action and the human_name of the record" do
      record = double(human_name: "Stay home")

      render_inline Admin::TableActionComponent.new(:edit, record, path: "/")

      expect(page).to have_link count: 1
      expect(page).to have_css "a[aria-label='Edit Stay home']", exact_text: "Edit"
    end

    it "uses the to_s method when there's no human_name" do
      record = double(to_s: "do_not_go_out")

      render_inline Admin::TableActionComponent.new(:edit, record, path: "/")

      expect(page).to have_link count: 1
      expect(page).to have_css "a[aria-label='Edit Do not go out']", exact_text: "Edit"
    end

    it "uses the human_name when there are both human_name and to_s" do
      record = double(human_name: "Stay home", to_s: "do_not_go_out")

      render_inline Admin::TableActionComponent.new(:edit, record, path: "/")

      expect(page).to have_link count: 1
      expect(page).to have_css "a[aria-label='Edit Stay home']", exact_text: "Edit"
    end
  end

  describe "data-confirm attribute" do
    it "is not rendered by default" do
      render_inline Admin::TableActionComponent.new(:edit, double, path: "/")

      expect(page).to have_link count: 1
      expect(page).not_to have_css "[data-confirm]"
    end

    it "is not rendered when confirm is nil" do
      render_inline Admin::TableActionComponent.new(:edit, double, path: "/", confirm: nil)

      expect(page).to have_link count: 1
      expect(page).not_to have_css "[data-confirm]"
    end

    it "renders with the given value" do
      render_inline Admin::TableActionComponent.new(:edit, double, path: "/", confirm: "Really?")

      expect(page).to have_link count: 1
      expect(page).to have_css "[data-confirm='Really?']"
    end

    context "when confirm is true" do
      it "includes a model translation when available" do
        record = double(
          model_name: double(i18n_key: "budget", human: "Bud"),
          human_name: "Participatory Budget 2015"
        )
        text = "Are you sure? Edit the budget 'Participatory Budget 2015'"

        render_inline Admin::TableActionComponent.new(:edit, record, path: "/", confirm: true)

        expect(page).to have_link count: 1
        expect(page).to have_css "[data-confirm=\"#{text}\"]"
      end

      it "uses the human name as default" do
        record = double(
          model_name: double(i18n_key: "i_dont_exist", human: "Whisper"),
          human_name: "Everywhere and nowhere"
        )
        text = "Are you sure? Edit Whisper 'Everywhere and nowhere'"

        render_inline Admin::TableActionComponent.new(:edit, record, path: "/", confirm: true)

        expect(page).to have_link count: 1
        expect(page).to have_css "[data-confirm=\"#{text}\"]"
      end

      it "includes a more detailed message for the destroy action" do
        record = double(
          model_name: double(i18n_key: "budget", human: "Bud"),
          human_name: "Participatory Budget 2015"
        )
        text = "Are you sure? This action will delete the budget " \
               "'Participatory Budget 2015' and can't be undone."

        render_inline Admin::TableActionComponent.new(:destroy, record, path: "/", confirm: true)

        expect(page).to have_link count: 1
        expect(page).to have_css "[data-confirm=\"#{text}\"]"
      end
    end
  end
end
