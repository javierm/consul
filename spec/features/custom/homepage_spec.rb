require "rails_helper"

describe "Home" do
  before { allow(I18n).to receive(:default_locale).and_return(:es) }

  scenario "has top links" do
    load Rails.root.join("db/custom_seeds.rb")

    visit root_path

    within ".top-links" do
      expect(page).to have_link "Gobierno abierto"
      expect(page).to have_link "Transparencia"
      expect(page).to have_link "Datos abiertos"
      expect(page).to have_link "Participación ciudadana"
    end
  end

  describe "navigation" do
    scenario "has a link to the home page" do
      visit root_path

      within "#navigation_bar" do
        expect(page).to have_link "Portada"
      end
    end
  end
end
