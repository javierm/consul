require_dependency Rails.root.join("app", "controllers", "users_controller").to_s

class UsersController
  alias_method :consul_show, :show
  before_action :authenticate_user!

  def show
    if @user != current_user
      raise CanCan::AccessDenied
    else
      consul_show
    end
  end
end
