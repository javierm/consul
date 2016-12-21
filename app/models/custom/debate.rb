require_dependency Rails.root.join('app', 'models', 'debate').to_s

class Debate
  validates :area, presence: true
  before_validation :set_default_area, if: :new_record?

  private
  def set_default_area
    self.area = I18n.t('debates.edit.area').values.first
  end
end
