require_dependency Rails.root.join("app", "models", "verification", "residence").to_s

class Verification::Residence
  validate :postal_code_in_valencia
  validate :residence_in_valencia

  def postal_code_in_valencia
    errors.add(:postal_code, I18n.t("verification.residence.new.error_not_allowed_postal_code")) unless valid_postal_code?
  end

  def residence_in_valencia
    return if errors.any?

    unless residency_valid?
      errors.add(:residence_in_valencia, false)
      store_failed_attempt
      Lock.increase_tries(user)
    end
  end

  private

    def residency_valid?
      @census_data.valid? &&
        @census_data.postal_code.to_s == postal_code &&
        @census_data.date_of_birth == date_of_birth
    end

    def valid_postal_code?
      postal_code =~ /^46/
    end
end
