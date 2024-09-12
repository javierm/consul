load Rails.root.join("app", "controllers", "management", "email_verifications_controller.rb")

class Management::EmailVerificationsController
  def create
    @email_verification = Verification::Management::Email.new(email_verification_params)

    if @email_verification.save
      @managed_user = nil
      render :sent
    else
      render :new
    end
  end
end
