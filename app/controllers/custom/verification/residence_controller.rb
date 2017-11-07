
require_dependency Rails.root.join('app', 'controllers', 'verification', 'residence_controller').to_s

class Verification::ResidenceController
  def new
    if current_user.residence_requested?
      redirect_to account_path
      return
    end

    @residence = Verification::Residence.new
  end

  def create
    if current_user.residence_requested?
      redirect_to account_path
      return
    end

    @residence = Verification::Residence.new(residence_params.merge(user: current_user, mode: :manual))
    if @residence.save
      # TODO Esto no se usa actualmente, pues el segundo paso de verificación es desde admin de forma masiva
      if @residence.user.residence_verified?
        redirect_to verified_user_path, notice: t('verification.residence.create.flash.success')
      else
        redirect_to account_path, notice: t('verification.residence.create.flash.requested')
      end
    else
      render :new
    end
  end

  private

    def residence_params
      params.require(:residence).permit(:document_number, :document_type, :common_name, :first_surname, :date_of_birth, :postal_code, :terms_of_service, :geozone_id)
    end
end
