module AreaFlaggable
  extend ActiveSupport::Concern

  included do
    scope :pending_area_review, -> { where(area_revised_at: nil, hidden_at: nil) }
  end

  def area_revised?
    area_revised_at.present?
  end

  def area_revised
    update(area_revised_at: Time.now)
  end

end
