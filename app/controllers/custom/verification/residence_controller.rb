
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

    @residence = Verification::Residence.new(residence_params.merge(user: current_user, mode: :check))
    if @residence.save
      if @residence.user.residence_verified?
        # NOTE: Mode :check always enters here. Mode empty if verification succeded
        redirect_to verified_user_path, notice: t('verification.residence.create.flash.success')
      else
        # NOTE: Mode :manual always enters here. Mode empty if verification failed
        redirect_to account_path, notice: t('verification.residence.create.flash.requested')
      end
    else
      render :new
    end
  end

  private

    def residence_params
      params.require(:residence).permit(:document_number, :document_type, :common_name, :first_surname, :date_of_birth, :postal_code, :terms_of_service, :geozone_id, :no_resident)
    end
end
