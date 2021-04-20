require_dependency Rails.root.join("app", "controllers", "admin", "users_controller").to_s

class Admin::UsersController
  has_filters %w[active erased residence_requested], only: :index
end
