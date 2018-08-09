class Users::SessionsController < Devise::SessionsController

  private

    def after_sign_in_path_for(resource)
      if !verifying_via_email? && resource.show_welcome_screen?
        welcome_path
      else
        resource.level_two_or_three_verified? ? super : new_residence_path
      end
    end

    def after_sign_out_path_for(resource)
      request.referer.present? ? request.referer : super
    end

    def verifying_via_email?
      return false if resource.blank?
      stored_path = session[stored_location_key_for(resource)] || ""
      stored_path[0..5] == "/email"
    end

end
