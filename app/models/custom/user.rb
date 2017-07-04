require_dependency Rails.root.join('app', 'models', 'user').to_s

class User
  include VerificationImproved

  has_many :answered_surveys
  has_many :failed_person_calls
end
