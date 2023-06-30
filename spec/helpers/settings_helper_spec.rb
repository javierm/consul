require "rails_helper"

RSpec.describe SettingsHelper do
  describe "#setting" do
    it "returns a hash with all settings values" do
      Setting["key1"] = "value1"
      Setting["key2"] = "value2"

      expect(setting["key1"]).to eq("value1")
      expect(setting["key2"]).to eq("value2")
      expect(setting["key3"]).to be nil
    end
  end

  describe "#feature?" do
    it "returns presence of feature flag setting value" do
      Setting["feature.f1"] = "active"
      Setting["feature.f2"] = ""
      Setting["feature.f3"] = nil

      expect(feature?("f1")).to eq("active")
      expect(feature?("f2")).to be nil
      expect(feature?("f3")).to be nil
      expect(feature?("f4")).to be nil
    end

    it "finds settings by the given name prefixed with 'process.' and returns its presence" do
      Setting["process.p1"] = "active"
      Setting["process.p2"] = ""
      Setting["process.p3"] = nil

      expect(feature?("p1")).to eq("active")
      expect(feature?("p2")).to be nil
      expect(feature?("p3")).to be nil
      expect(feature?("p4")).to be nil
    end

    it "finds settings by the full key name and returns its presence" do
      Setting["map.feature.f1"] = true
      Setting["map.feature.f2"] = false
      Setting["map.feature.f3"] = nil
      Setting["map.feature.f4"] = ""

      expect(feature?("map.feature.f1")).to eq("t")
      expect(feature?("map.feature.f2")).to be nil
      expect(feature?("map.feature.f3")).to be nil
      expect(feature?("map.feature.f4")).to be nil
    end
  end
end
