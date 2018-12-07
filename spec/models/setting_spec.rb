require 'rails_helper'

describe Setting do
  before do
    described_class["official_level_1_name"] = 'Stormtrooper'
  end

  it "returns the overriden setting" do
    expect(described_class['official_level_1_name']).to eq('Stormtrooper')
  end

  it "shoulds return nil" do
    expect(described_class['undefined_key']).to eq(nil)
  end

  it "persists a setting on the db" do
    expect(described_class.where(key: 'official_level_1_name', value: 'Stormtrooper')).to exist
  end

  describe "#feature_flag?" do
    it "is true if key starts with 'feature.'" do
      setting = described_class.create(key: 'feature.whatever')
      expect(setting.feature_flag?).to eq true
    end

    it "is false if key does not start with 'feature.'" do
      setting = described_class.create(key: 'whatever')
      expect(setting.feature_flag?).to eq false
    end
  end

  describe "#enabled?" do
    it "is true if feature_flag and value present" do
      setting = described_class.create(key: 'feature.whatever', value: 1)
      expect(setting.enabled?).to eq true

      setting.value = "true"
      expect(setting.enabled?).to eq true

      setting.value = "whatever"
      expect(setting.enabled?).to eq true
    end

    it "is false if feature_flag and value blank" do
      setting = described_class.create(key: 'feature.whatever')
      expect(setting.enabled?).to eq false

      setting.value = ""
      expect(setting.enabled?).to eq false
    end

    it "is false if not feature_flag" do
      setting = described_class.create(key: 'whatever', value: "whatever")
      expect(setting.enabled?).to eq false
    end
  end

  describe "#banner_style?" do
    it "is true if key starts with 'banner-style.'" do
      setting = described_class.create(key: 'banner-style.whatever')
      expect(setting.banner_style?).to eq true
    end

    it "is false if key does not start with 'banner-style.'" do
      setting = described_class.create(key: 'whatever')
      expect(setting.banner_style?).to eq false
    end
  end

  describe "#banner_img?" do
    it "is true if key starts with 'banner-img.'" do
      setting = described_class.create(key: 'banner-img.whatever')
      expect(setting.banner_img?).to eq true
    end

    it "is false if key does not start with 'banner-img.'" do
      setting = described_class.create(key: 'whatever')
      expect(setting.banner_img?).to eq false
    end
  end

  describe ".add_new_settings" do
    context "default settings with strings" do
      before do
        allow(Setting).to receive(:defaults).and_return({ stub: "stub" })
      end

      it "creates the setting if it doesn't exist" do
        expect(Setting.where(key: :stub)).to be_empty

        Setting.add_new_settings

        expect(Setting.where(key: :stub)).not_to be_empty
        expect(Setting.find_by(key: :stub).value).to eq "stub"
      end

      it "doesn't modify custom values" do
        Setting["stub"] = "custom"

        Setting.add_new_settings

        expect(Setting.find_by(key: :stub).value).to eq "custom"
      end

      it "doesn't modify custom nil values" do
        Setting["stub"] = nil

        Setting.add_new_settings

        expect(Setting.find_by(key: :stub).value).to be nil
      end
    end

    context "nil default settings" do
      before do
        allow(Setting).to receive(:defaults).and_return({ stub: nil })
      end

      it "creates the setting if it doesn't exist" do
        expect(Setting.where(key: :stub)).to be_empty

        Setting.add_new_settings

        expect(Setting.where(key: :stub)).not_to be_empty
        expect(Setting.find_by(key: :stub).value).to be_nil
      end

      it "doesn't modify custom values" do
        Setting["stub"] = "custom"

        Setting.add_new_settings

        expect(Setting.find_by(key: :stub).value).to eq "custom"
      end
    end
  end
end
