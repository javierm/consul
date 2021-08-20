require_dependency Rails.root.join("app", "models", "proposal").to_s

class Proposal < ApplicationRecord
  translates :details, touch: true
  translates :request, touch: true

  globalize_accessors

  scope :voting_enabled, -> { where(voting_enabled: true) }
  scope :voting_disabled, -> { where(voting_enabled: false) }
  scope :voting_pending, -> { where(voting_enabled: nil) }

  def voting_in_review?
    voting_enabled.nil?
  end

  def voting_disabled?
    voting_enabled == false
  end
end