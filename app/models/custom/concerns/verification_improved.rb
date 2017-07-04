module VerificationImproved
  extend ActiveSupport::Concern

  included do
    scope :incomplete_verification, -> { where("(users.residence_verified_at IS NULL AND (users.failed_census_calls_count > ? or users.failed_person_calls_count > ?)) OR (users.residence_verified_at IS NOT NULL AND (users.unconfirmed_phone IS NULL OR users.confirmed_phone IS NULL) OR (users.residence_requested_at is not null and users.residence_verified_at is null))", 0, 0)  }
    scope :residence_requested, -> { where("users.residence_requested_at is not null and users.residence_verified_at is null") }
  end

  def pending_verification?
    residence_requested_at? && !residence_verified? && failed_census_calls_count == 0 && failed_person_calls_count == 0
  end

  def residence_requested?
    residence_requested_at? && !residence_verified?
  end

  def failed_age_verification?
    !residence_verified? && failed_person_calls_count > 0
  end

end
