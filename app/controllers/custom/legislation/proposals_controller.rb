load Rails.root.join("app", "controllers", "legislation", "proposals_controller.rb")

class Legislation::ProposalsController
  alias_method :consul_allowed_params, :allowed_params

  private

    def allowed_params
      consul_allowed_params - [:geozone_id]
    end
end
