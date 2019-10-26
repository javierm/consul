module I18nFallbacks
  extend ActiveSupport::Concern

  included do
    before_action :initialize_i18n_fallbacks
  end

  private

    def initialize_i18n_fallbacks
      Globalize.set_fallbacks_to_all_available_locales
    end
end
