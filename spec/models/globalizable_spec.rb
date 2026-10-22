require "rails_helper"

describe Globalizable do
  before do
    dummy_banner = Class.new(ApplicationRecord) do
      def self.name
        "DummyBanner"
      end
      self.table_name = "banners"

      translates :title, touch: true
      translates :description, touch: true
      include Globalizable

      has_many :translations, class_name: "DummyBanner::Translation",
                              foreign_key: "banner_id",
                              autosave: true

      validates_translation :title, presence: true, length: { minimum: 7 }
      validates_translation :description, presence: true
    end

    stub_const("DummyBanner", dummy_banner)
  end

  describe ".validates_translation" do
    it "validates length for the default locale" do
      Setting["locales.default"] = "es"

      dummy = DummyBanner.new
      dummy.translations.build(locale: "es", title: "Short")
      dummy.translations.build(locale: "fr", title: "Long enough")

      I18n.with_locale(:fr) do
        expect(dummy).not_to be_valid
      end
    end

    it "does not validate length for other locales" do
      Setting["locales.default"] = "es"

      dummy = DummyBanner.new
      dummy.translations.build(locale: "es", title: "Long enough", description: "Present")
      dummy.translations.build(locale: "fr", title: "Long enough", description: "Present")
      dummy.translations.build(locale: "en", title: "Short", description: "Present")

      I18n.with_locale(:fr) do
        expect(dummy).to be_valid
      end
    end

    describe "validation error placement" do
      context "when creating a record" do
        it "reports the error on the attribute when it is sent directly" do
          dummy = DummyBanner.new(title: "Short", description: "Present")

          expect(dummy).not_to be_valid
          expect(dummy.errors.count).to eq 1
          expect(dummy.errors[:title]).to be_present
          expect(dummy.errors["translations.title"]).to be_blank
        end

        it "reports the error on the translations when it is sent through the translations" do
          dummy = DummyBanner.new(translations_attributes: [{ locale: "en",
                                                              title: "Short",
                                                              description: "Present" }])

          expect(dummy).not_to be_valid
          expect(dummy.errors.count).to eq 1
          expect(dummy.errors["translations.title"]).to be_present
          expect(dummy.errors[:title]).to be_blank
        end
      end

      context "when updating a record" do
        let(:dummy) { DummyBanner.create!(title: "Long enough", description: "Present") }

        it "reports the error on the attribute when it is sent directly" do
          dummy.update(title: "Short")

          expect(dummy.errors.count).to eq 1
          expect(dummy.errors[:title]).to be_present
          expect(dummy.errors["translations.title"]).to be_blank
        end

        it "reports the error on the translations when it is sent through the translations" do
          dummy.update(translations_attributes: [{ id: dummy.translations.first.id,
                                                   locale: "en",
                                                   title: "Short",
                                                   description: "Present" }])

          expect(dummy.errors.count).to eq 1
          expect(dummy.errors["translations.title"]).to be_present
          expect(dummy.errors[:title]).to be_blank
        end
      end
    end

    it "reports an error when the title is set to nil and another translation exists" do
      record = DummyBanner.create!(title: "Original title", description: "A description")

      I18n.with_locale(:es) do
        record.update!(title: "Título original", description: "Una descripción")
      end

      expect(record.update(title: nil)).to be false
      expect(record.errors.full_messages).to include(a_string_matching(/blank/))
      expect(DummyBanner.find(record.id).title).to eq "Original title"
    end

    it "reports an error when a new translation is missing a required attribute" do
      record = DummyBanner.create!(title: "Original title", description: "A description")

      updated = I18n.with_locale(:es) { record.update(title: "Título en español") }

      expect(updated).to be false
      expect(record.errors.full_messages).to include(a_string_matching(/blank/))
      expect(DummyBanner.find(record.id).translations.map(&:locale)).to eq [:en]
    end
  end
end
