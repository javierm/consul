require_dependency Rails.root.join("app", "models", "verification", "residence").to_s

class Verification::Residence
  validate :postal_code_in_arucas
  validate :residence_in_arucas

  def postal_code_in_arucas
    errors.add(:postal_code, I18n.t("verification.residence.new.error_not_allowed_postal_code")) unless valid_postal_code?
  end

  def residence_in_arucas
    return if errors.any?

    unless residency_valid?
      errors.add(:residence_in_arucas, false)
      store_failed_attempt
      Lock.increase_tries(user)
    end
  end

  private

    def valid_postal_code?
      postal_code.in?(%w[35000 35400 35404 35411 35412 35413 35414 35415 35418])
    end

    def residency_valid?
      @census_data.valid? &&
        @census_data.date_of_birth == date_of_birth
    end
end
