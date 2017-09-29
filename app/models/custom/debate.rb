require_dependency Rails.root.join('app', 'models', 'debate').to_s

class Debate
  validates :area, presence: true

  def votable_by?(user)
    return false unless user.level_two_or_three_verified?
    super(user)
  end
end
