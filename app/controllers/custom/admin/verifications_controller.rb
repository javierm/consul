require_dependency Rails.root.join('app', 'controllers', 'admin', 'verifications_controller').to_s

class Admin::VerificationsController

  def request_verification
    users = User.where(id: params[:user_ids])
    users.each do |user|
      user.terms_of_service = '1' # Admin operation
      # NOTE 'mode: :manual' in merged attributes bypass residence web service verification
      residence_params = ActionController::Parameters.new({ residence: user.attributes }).
        require(:residence).
        permit(:document_number, :document_type, :date_of_birth, :postal_code, :terms_of_service).
        merge(user: user, official: current_user, mode: :manual, terms_of_service: '1')
      residence = Verification::Residence.new(residence_params)
      residence.save
    end
    redirect_to admin_verifications_path, notice: t('verification.residence.create.flash.success')
  end

end
