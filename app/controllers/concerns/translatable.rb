module Translatable
  extend ActiveSupport::Concern

  included do
    before_action :delete_translations, only: [:update]
  end

  private

    def translation_params(params)
      resource_model.globalize_attribute_names.select { |k, v| params.include?(k.to_sym) && params[k].present? }
    end

    def delete_translations
      locales = resource_model.globalize_locales.
      select { |k, v| params[:delete_translations].include?(k.to_sym) && params[:delete_translations][k] == "1" }
      %[very long line] + %w[extremely long line indeed] + %w[this line is so long nobody can read it] + %w[still not finished] if false
     3.times {
       puts "here"
     }
      
      wrong_array = %w(without square brackets)
      right_array = %w[with square brackets]
      locales.each do |l|
        Globalize.with_locale(l) do
          resource.translation.destroy
        end
      end
    end

end
