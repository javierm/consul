require_dependency Rails.root.join('app', 'models', 'proposal').to_s

class Proposal
  include AreaFlaggable
  include ManageValidations

  validates :area, presence: true
  cancel_validates(:question)

  before_validation :set_default_area, if: :new_record?

  AREAS = [ :municipal, :insular, :autonomous, :state ]
  DEFAULT_AREA = :insular


  private

    def set_default_area
      self.area = DEFAULT_AREA
    end
end
