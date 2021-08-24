require_dependency Rails.root.join("app", "controllers", "users_controller").to_s

class UsersController
  alias_method :consul_show, :show
  before_action :authenticate_user!

  def show
    unless @user == current_user
      @valid_filters = @valid_filters.reject { |filter| filter.to_s == "follows" }
    end

    if params[:filter] == "follows" && @user != current_user
      raise ActionController::RoutingError, "Not Found"
    else
      consul_show
    end
  end
end
