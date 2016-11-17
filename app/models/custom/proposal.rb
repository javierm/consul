require_dependency Rails.root.join('app', 'models', 'proposal').to_s

class Proposal
  include AreaFlaggable

  validates :area, presence: true

  before_validation :set_default_area

  AREAS = [ :municipal, :insular, :autonomous, :state ]
  DEFAULT_AREA = :insular

  private

    def set_default_area
      self.area ||= DEFAULT_AREA
      self.area_revised_at = Time.now unless area_was.nil?
    end
end
