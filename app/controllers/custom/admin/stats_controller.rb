require_dependency Rails.root.join("app", "controllers", "admin", "stats_controller").to_s

class Admin::StatsController < Admin::BaseController
  def show
    redirect_to polls_admin_stats_path
  end
end
