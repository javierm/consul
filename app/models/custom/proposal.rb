require_dependency Rails.root.join('app', 'models', 'proposal').to_s

class Proposal
  include AreaFlaggable
  include ManageValidations

  validates :area, presence: true
  cancel_validates(:question)

  before_validation :set_default_area, if: :new_record?

  AREAS = [ :municipal, :insular, :autonomous, :state ]
  DEFAULT_AREA = :insular

  def votable_by?(user)
    user && user.level_two_or_three_verified? && !user.no_resident
  end


  private

    def set_default_area
      self.area = DEFAULT_AREA
    end
end
