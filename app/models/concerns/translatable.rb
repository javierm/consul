module Translatable
  MIN_TRANSLATIONS = 1
  extend ActiveSupport::Concern

  class_methods do
    def translation_class
      "#{name}::Translation".constantize
    end

    def validates_translation(method, options = {})
      validates(method, options.merge(if: lambda { |resource| resource.translations.blank? }))
      if options.include?(:length)
        lenght_validate = { length: options[:length] }
        translation_class.instance_eval do
          validates method, lenght_validate.merge(if: lambda { |translation| translation.locale == I18n.default_locale })
        end
        if options.count > 1
          translation_class.instance_eval do
            validates method, options.reject { |key| key == :length }
          end
        end
      else
        translation_class.instance_eval { validates method, options }
      end
    end

    def translation_class_delegate(method)
      translation_class.instance_eval { delegate method, to: :translated_model }
    end
  end

  included do
    accepts_nested_attributes_for :translations, allow_destroy: true

    validate :check_translations_number, on: :update, if: :translations_required?
    after_validation :copy_error_to_current_translation, on: :update

    def locales_not_marked_for_destruction
      translations.reject(&:marked_for_destruction?).map(&:locale)
    end

    def locales_marked_for_destruction
      I18n.available_locales - locales_not_marked_for_destruction
    end

    def locales_persisted_and_marked_for_destruction
      translations.select { |t| t.persisted? && t.marked_for_destruction? }.map(&:locale)
    end

    def translations_required?
      translated_attribute_names.any? { |attr| required_attribute?(attr) }
    end

    def translation_for(locale)
      translations.in_locale(locale) || translations.build(locale: locale)
    end

    if self.paranoid? && translation_class.attribute_names.include?("hidden_at")
      translation_class.send :acts_as_paranoid, column: :hidden_at
    end

    scope :with_translation, -> { joins("LEFT OUTER JOIN #{translations_table_name} ON #{table_name}.id = #{translations_table_name}.#{reflections["translations"].foreign_key} AND #{translations_table_name}.locale='#{I18n.locale}'") }

    private

      def required_attribute?(attribute)
        presence_validators = [ActiveModel::Validations::PresenceValidator,
          ActiveRecord::Validations::PresenceValidator]

        attribute_validators(attribute).any? { |validator| presence_validators.include? validator }
      end

      def attribute_validators(attribute)
        self.class.validators_on(attribute).map(&:class)
      end

      def check_translations_number
        errors.add(:base, :translations_too_short) unless traslations_count_valid?
      end

      def traslations_count_valid?
        translations.reject(&:marked_for_destruction?).count >= MIN_TRANSLATIONS
      end

      def copy_error_to_current_translation
        return unless errors.added?(:base, :translations_too_short)

        if locales_persisted_and_marked_for_destruction.include?(I18n.locale)
          locale = I18n.locale
        else
          locale = locales_persisted_and_marked_for_destruction.first
        end

        translation = translation_for(locale)
        translation.errors.add(:base, :translations_too_short)
      end

      def searchable_translated_values
        values = {}
        translations.each do |translation|
          Mobility.with_locale(translation.locale) do
            values.merge! searchable_translations_definitions
          end
        end
        values
      end
  end
end
