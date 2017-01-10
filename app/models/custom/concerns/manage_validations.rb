module ManageValidations
  extend ActiveSupport::Concern

  included do
    # Disables in custom models validations for a field defined in main model
    def self.cancel_validates(field)
      _validators.reject!{ |key, _| key == field }

      _validate_callbacks.each do |callback|
        _validate_callbacks.delete(callback) if callback.filter.respond_to?(:attributes) && callback.filter.attributes == [field] || callback.filter == field
      end
    end
  end

end
