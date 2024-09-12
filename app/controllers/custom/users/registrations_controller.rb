load Rails.root.join("app", "controllers", "users", "registrations_controller.rb")

class Users::RegistrationsController
  private

    alias_method :consul_allowed_params, :allowed_params

    def allowed_params
      consul_allowed_params + [:date_of_birth, :geozone_id, :gender]
    end
end
