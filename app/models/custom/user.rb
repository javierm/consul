require_dependency Rails.root.join("app", "models", "user").to_s

class User
  scope :other, -> { where(gender: "other") }
end
