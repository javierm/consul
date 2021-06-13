require "rails_helper"

describe Budgets::Investments::VotesComponent, type: :component do
  describe "vote link" do
    context "when investment shows votes" do
      let(:investment) { create(:budget_investment, title: "Renovate sidewalks in Main Street") }
      let(:component) { Budgets::Investments::VotesComponent.new(investment, investment_votes: []) }

      before { allow(investment).to receive(:should_show_votes?).and_return(true) }

      it "displays a button to support the investment to identified users" do
        allow(controller).to receive(:current_user).and_return(create(:user))

        render_inline component

        expect(page).to have_button count: 1
        expect(page).to have_button "Support", title: "Support this project", disabled: false
        expect(page).to have_button "Support Renovate sidewalks in Main Street"
      end

      it "disables the button to support the investment to unidentified users" do
        allow(controller).to receive(:current_user).and_return(nil)

        render_inline component

        expect(page).to have_button "Support", disabled: true
      end
    end
  end
end
