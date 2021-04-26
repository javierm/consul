require_dependency Rails.root.join("app", "models", "comment").to_s

class Comment
  scope :not_as_admin_or_moderator, -> do
    where("administrator_id IS NULL OR budget_manager_id IS NULL").where("moderator_id IS NULL")
  end

  def as_administrator?
    administrator_id.present? || budget_manager_id.present?
  end
end
