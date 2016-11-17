require_dependency Rails.root.join('app', 'controllers', 'moderation', 'proposals_controller').to_s

class Moderation::ProposalsController
  has_filters %w{pending_flag_review all with_ignored_flag pending_area_review}, only: :index
end
