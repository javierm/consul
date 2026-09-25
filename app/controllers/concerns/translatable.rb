module Translatable
  extend ActiveSupport::Concern

  private

    def translation_params(resource_model, options = {})
      base_attributes = [:id, :locale, :_destroy]

      attributes = if options[:only]
                     Array(options[:only])
                   else
                     resource_model.translated_attribute_names
                   end

      filtered_attributes = attributes - Array(options[:except])

      [*filtered_attributes, { translations_attributes: filtered_attributes + base_attributes }]
    end
end
