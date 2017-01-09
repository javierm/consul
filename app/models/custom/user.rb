require_dependency Rails.root.join('app', 'models', 'user').to_s

class User
  has_many :answered_surveys
end
