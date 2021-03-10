require_dependency Rails.root.join("app", "models", "verification", "residence").to_s

class Verification::Residence
  validates :gender, :name, :first_surname, presence: true
  validates :last_surname, presence: true, if: -> { document_type == 1 }

  validate :postal_code_in_valencia
  validate :residence_in_valencia

  GENDERS = %i[male female other].freeze

  undef gender
  attr_accessor :gender, :name, :first_surname, :last_surname

  def save
    return false unless valid?

    user.take_votes_if_erased_document(document_number, document_type)

    user.update(document_number:       document_number,
                document_type:         document_type,
                geozone:               geozone,
                postal_code:           postal_code,
                date_of_birth:         date_of_birth.in_time_zone.to_datetime,
                gender:                gender,
                residence_verified_at: Time.current,
                services_results:      @census_data.data)
  end

  def postal_code_in_valencia
    errors.add(:postal_code, I18n.t("verification.residence.new.error_not_allowed_postal_code")) unless valid_postal_code?
  end

  def residence_in_valencia
    return if errors.any?

    unless residency_valid?
      if @census_data.respond_to?(:error) && @census_data.error =~ /^Servicio no disponible/
         errors.add(:base, I18n.t("verification.residence.new.error_service_not_available"))
        return
      end
      errors.add(:residence_in_valencia, false)
      store_failed_attempt
      Lock.increase_tries(user)
    end
  end

  def store_failed_attempt
    FailedCensusCall.create(
      user: user,
      document_number: document_number,
      document_type: document_type,
      date_of_birth: date_of_birth,
      postal_code: postal_code,
      services_results: @census_data.data
    )
  end

  private
    def retrieve_census_data
      other_data = { date_of_birth: date_of_birth, postal_code: postal_code, name: name, first_surname: first_surname, last_surname: last_surname }
      @census_data = CensusCaller.new.call(document_type, document_number, other_data)
    end

    def residency_valid?
      @census_data.valid? &&
        @census_data.postal_code.to_s == postal_code &&
        @census_data.date_of_birth == date_of_birth
    end

    def valid_postal_code?
      postal_code =~ /^03|12|46/
    end
end
