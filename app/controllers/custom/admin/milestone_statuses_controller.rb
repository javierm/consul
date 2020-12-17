require_dependency Rails.root.join("app", "controllers", "admin", "milestone_statuses_controller").to_s

class Admin::MilestoneStatusesController
  load_and_authorize_resource :status, class: "Milestone::Status"
end
