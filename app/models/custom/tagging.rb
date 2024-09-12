load Rails.root.join("app", "models", "tagging.rb")

class Tagging
  include Auditable
end
