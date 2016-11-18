require_dependency Rails.root.join('app', 'models', 'debate').to_s

class Debate
  validates :area, presence: true
end
