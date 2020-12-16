require_dependency Rails.root.join("app", "models", "user").to_s

class User
  has_one :legislator

  scope :legislators, -> { joins(:legislator) }

  def legislator?
    legislator.present?
  end

  def show_welcome_screen?
    verification = Setting["feature.user.skip_verification"].present? ? true : unverified?
    sign_in_count == 1 && verification && !organization && !administrator? && !legislator?
  end
end
