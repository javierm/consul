require_dependency Rails.root.join("app", "models", "user").to_s

class User
  has_one :legislator
  has_one :budget_manager
  has_many :legislation_processes, inverse_of: :user

  scope :residence_requested, -> { where.not(residence_requested_at: nil).where(residence_verified_at: nil) }
  scope :legislators, -> { joins(:legislator) }
  scope :budget_managers, -> { joins(:budget_manager) }
  scope :other, -> { where(gender: "other") }

  def legislator?
    legislator.present?
  end

  def budget_manager?
    budget_manager.present?
  end

  def show_welcome_screen?
    verification = Setting["feature.user.skip_verification"].present? ? true : unverified?
    sign_in_count == 1 && verification && !organization && !administrator? && !legislator? && !budget_manager?
  end

  def self.soft_minimum_required_age
    (Setting["soft_min_age_to_participate"] || 12).to_i
  end

  def residence_requested?
    residence_requested_at? && !residence_verified_at?
  end

  def residence_requested_age?
    age = (residence_requested_at - date_of_birth) / 1.year
    age >= User.soft_minimum_required_age && age < User.minimum_required_age
  end

  def residence_requested_foreign?
    foreign_residence?
  end
end
