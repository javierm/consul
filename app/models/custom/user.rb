require_dependency Rails.root.join("app", "models", "user").to_s

class User
  devise :lockable if Rails.application.config.devise_lockable

  def self.maximum_attempts
    (Tenant.current_secrets.dig(:security, :lockable, :maximum_attempts) || 20).to_i
  end

  def self.unlock_in
    (Tenant.current_secrets.dig(:security, :lockable, :unlock_in) || 1).to_i.hours
  end

  def self.password_complexity
    if Tenant.current_secrets.dig(:security, :password_complexity)
      { digit: 1, lower: 1, symbol: 0, upper: 1 }
    else
      { digit: 0, lower: 0, symbol: 0, upper: 0 }
    end
  end
end
