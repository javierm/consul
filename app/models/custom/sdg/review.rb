require_dependency Rails.root.join("app", "models", "sdg", "review").to_s

class SDG::Review
  audited on: [:create, :update, :destroy]
end