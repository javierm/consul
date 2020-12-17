require_dependency Rails.root.join("app", "controllers", "verification", "residence_controller").to_s

class Verification::ResidenceController
  def create
    @residence = Verification::Residence.new(residence_params.merge(user: current_user))
    if @residence.save
      # we don't want to use sms verification
      current_user.update!(unconfirmed_phone: '-', confirmed_phone: '-')
      ahoy.track(:level_2_user, user_id: current_user.id) rescue nil
      current_user.update(verified_at: Time.current)

      redirect_to verified_user_path, notice: t("verification.residence.create.flash.success")
    else
      render :new
    end
  end
  
  private
  
    def residence_params
      params.require(:residence).permit(:document_number, :document_type, :date_of_birth, :postal_code, :terms_of_service, :gender)
    end
 
end