require_dependency Rails.root.join('app', 'controllers', 'proposals_controller').to_s

class ProposalsController
  has_orders %w{confidence_score hot_score created_at relevance archival_date}, only: :index
end
