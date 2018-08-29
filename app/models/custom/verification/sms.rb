require_dependency Rails.root.join('app', 'models', 'verification', 'sms').to_s
class Verification::Sms

  def uniqness_phone
    true
  end

end
