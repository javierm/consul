
require_dependency Rails.root.join('app', 'models', 'verification', 'residence').to_s

class Verification::Residence

  attr_accessor :user, :document_number, :document_type, :date_of_birth, :postal_code, :geozone_id, :terms_of_service, :official, :mode

  validates_presence_of :official, if: Proc.new { |vr| vr.user.residence_requested_at? }

  before_validation :call_census_api, if: Proc.new { |vr| vr.user.residence_requested_at? && mode != :manual }
  before_validation :call_person_api, if: Proc.new { |vr| vr.user.residence_requested_at? }

  validate :postal_code_in_gran_canaria
  validate :residence_in_gran_canaria, if: Proc.new { |vr| vr.user.residence_requested_at? && mode != :manual }
  validate :allowed_age, if: Proc.new { |vr| vr.user.residence_requested_at? }

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

    if !age_valid? || self.date_of_birth > 16.years.ago
      errors.add(:date_of_birth, I18n.t('verification.residence.new.error_not_allowed_age'))
      store_failed_attempt(:person)
      Lock.increase_tries(user) if mode == :manual || residency_valid? # Only increase lock if not already increased by residency
    end
  end

  def save
    unless valid?
      return user
    end

    if user.residence_requested_at?
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
                  geozone_id:             geozone_id,
                  postal_code:            postal_code,
                  date_of_birth:          date_of_birth,
                  residence_requested_at: Time.now)
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
    klass.create(attrs)
  end

  def geozone
    Geozone.where(census_code: postal_code).first
  end

  private

    def call_person_api
      @person_api_response = PersonApi.new.call(document_type, document_number, official.username, official.document_number)
    end

    def residency_valid?
      @census_api_response.valid? &&
      @census_api_response.postal_code == postal_code
    end

    def age_valid?
      @person_api_response.valid? &&
      @person_api_response.date_of_birth == date_of_birth.to_date
    end

    def valid_postal_code?
      postal_code =~ /^35/
    end

end
