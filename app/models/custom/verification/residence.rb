
require_dependency Rails.root.join('app', 'models', 'verification', 'residence').to_s

class Verification::Residence

  attr_accessor :user, :document_number, :document_type, :common_name, :first_surname, :date_of_birth, :postal_code, :geozone_id, :terms_of_service, :official, :mode

  # NOTE mode == :manual indicates use of age verification request only
  # NOTE mode == :check indicates no verification needed (user declares residence)

  validates_presence_of :official, if: Proc.new { |vr| vr.user.residence_requested? && mode == :manual }

  before_validation :retrieve_census_data, if: Proc.new { |vr| mode.nil? }
  before_validation :retrieve_person_data, if: Proc.new { |vr| vr.user.residence_requested? && mode == :manual }

  validate :postal_code_in_gran_canaria
  validate :residence_in_gran_canaria, if: Proc.new { |vr| mode.nil? }
  validate :allowed_age
  validate :spanish_id, if: Proc.new { |vr| vr.document_type == "1"}

  def postal_code_in_gran_canaria
    errors.add(:postal_code, I18n.t('verification.residence.new.error_not_allowed_postal_code')) unless valid_postal_code?
  end

  def residence_in_gran_canaria
    return if errors.any?

    unless residency_valid?
      errors.add(:residence_in_gran_canaria, false)
      # Only store one failed attempt between census and person apis
      store_failed_attempt(:census)
      Lock.increase_tries(user)
    end
  end

  def allowed_age
    return if errors[:date_of_birth].any?

    if self.date_of_birth > 16.years.ago
      errors.add(:date_of_birth, I18n.t('verification.residence.new.error_not_allowed_age'))
    end

    if user.residence_requested? && !age_valid?
      errors.add(:date_of_birth, I18n.t('verification.residence.new.error_wrong_age'))
      store_failed_attempt(:person)
      Lock.increase_tries(user) if mode == :manual || residency_valid? # Only increase lock if not already increased by residency
    end
  end

  def spanish_id
    return if errors.any?
    errors.add(:document_number, I18n.t('verification.residence.new.error_invalid_spanish_id')) unless valid_spanish_id?
  end

  def save
    return false unless valid?

    if user.residence_requested? && mode == :manual
      # Updates user data with verified attributes
      attrs = { residence_verified_at: Time.now }
      # TODO Revisar el guardado de geozone
      attrs[:geozone] = geozone unless mode == :manual
      attrs[:gender] = gender unless mode == :manual
      user.update(attrs)
    else
      # Saves user form data from verification request
      user.update(document_number:        document_number,
                  document_type:          document_type,
                  common_name:            common_name,
                  first_surname:          first_surname,
                  geozone_id:             geozone_id,
                  postal_code:            postal_code,
                  date_of_birth:          date_of_birth,
                  residence_verified_at:  (Time.now if mode != :manual),
                  residence_requested_at: (Time.now if mode == :manual))
    end
  end

  def document_number_uniqueness
    errors.add(:document_number, I18n.t('errors.messages.taken')) if User.where(document_number: document_number).where.not(id: user.id).any?
  end

  def store_failed_attempt(klass_name = :census)
    klass = klass_name == :census ? FailedCensusCall : FailedPersonCall
    attrs = {
      user: user,
      document_number: document_number,
      document_type:   document_type,
      date_of_birth:   date_of_birth,
    }
    attrs[:postal_code] = postal_code if klass_name == :census
    if klass_name == :person
      attrs[:common_name] = common_name
      attrs[:first_surname] = first_surname
      attrs[:response] = @person_api_response.error
    end
    klass.create(attrs)
  end

  def geozone
    Geozone.where(census_code: postal_code).first
  end

  private

    def retrieve_person_data
      @person_api_response = PersonApi.new.call(document_type, document_number, first_surname, official.username, official.document_number)
    end

    def residency_valid?
      @census_api_response.valid? &&
      @census_api_response.postal_code == postal_code
    end

    def age_valid?
      api_response = @person_api_response || @census_api_response
      api_response.valid? &&
      api_response.date_of_birth == date_of_birth.to_date
    end

    def valid_postal_code?
      postal_code =~ /^35/
    end

    def valid_spanish_id?
      value = document_number.upcase
      return false unless value.match(/^[0-9]{8}[a-z]$/i)
      letters = "TRWAGMYFPDXBNJZSQVHLCKE"
      check = value.slice!(value.length - 1)
      calculated_letter = letters[value.to_i % 23].chr
      return check === calculated_letter
    end
end
