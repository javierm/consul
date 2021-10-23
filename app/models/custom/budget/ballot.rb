require_dependency Rails.root.join("app", "models", "budget", "ballot").to_s

class Budget
  class Ballot
    audited on: [:create, :update, :destroy]
  end
end