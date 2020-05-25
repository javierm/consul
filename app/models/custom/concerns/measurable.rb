require_dependency Rails.root.join('app', 'models', 'concerns', 'measurable').to_s

module Measurable
  class_methods do
    def description_max_length
      20000
    end
  end
end
