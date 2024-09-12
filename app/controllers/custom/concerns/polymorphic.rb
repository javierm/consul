load Rails.root.join("app", "controllers", "concerns", "polymorphic.rb")

module Polymorphic
  private

    alias_method :consul_resource, :resource

    def resource
      if resource_model.to_s == "Legislation::Process"
        @resource ||= instance_variable_get(:@process)
      else
        consul_resource
      end
    end
end
