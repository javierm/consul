load Rails.root.join("app", "controllers", "admin", "stats_controller.rb")

class Admin::StatsController
  def tags
    @tags = Tag.order(taggings_count: :desc).page(params[:page])
  end
end
