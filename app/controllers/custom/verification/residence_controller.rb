
require_dependency Rails.root.join('app', 'controllers', 'verification', 'residence_controller').to_s

class Verification::ResidenceController
  def create
    @residence = Verification::Residence.new(residence_params.merge(user: current_user))
    if @residence.save
      # TODO Esto no se usa actualmente, pues el segundo paso de verificación es desde admin de forma másiva
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
      params.require(:residence).permit(:document_number, :document_type, :date_of_birth, :postal_code, :terms_of_service, :geozone_id)
    end
end
