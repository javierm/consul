require "rails_helper"

describe Taggable do
  describe "#sanitize_tag_list" do
    it "uses the title when available" do
      dummy_debate = Class.new(ApplicationRecord) do
        def self.name
          "DummyDebate"
        end
        self.table_name = "debates"

        include Taggable
      end
      stub_const("DummyDebate", dummy_debate)

      debate = DummyDebate.new(tag_list: %w[x=1 y?z])
      debate.validate!

      expect(debate.tag_list).to eq(%w[x1 yz])
    end
  end
end
