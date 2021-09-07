module HasAttachment
  extend ActiveSupport::Concern

  class_methods do
    def has_attachment(attribute)
      has_one_attached attribute
    end
  end
end
