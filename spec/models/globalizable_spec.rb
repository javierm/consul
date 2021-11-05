require "rails_helper"

describe Globalizable do
  it "doesn't require a translation when translatable fields require conditional presence" do
    dummy_translation = Class.new do
      include ActiveModel::Model
      attr_accessor :title, :locale
      validates :locale, presence: true
    end

    stub_const("DummyTranslation", dummy_translation)

    dummy_model = Class.new do
      include ActiveModel::Model
      attr_accessor :title, :translations

      def self.globalize_accessors; end

      def self.accepts_nested_attributes_for(...); end

      def self.after_validation(...); end

      def self.paranoid?; end

      def self.translation_class
        DummyTranslation
      end

      def translated_attribute_names
        [:title]
      end

      include Globalizable
      validate :check_translations_number, if: :translations_required?
      validates_translation :title, presence: true, unless: -> { true }

      def translations
        @translations ||= []
      end
    end

    stub_const("DummyModel", dummy_model)

    expect(DummyModel.new).to be_valid
  end
end
