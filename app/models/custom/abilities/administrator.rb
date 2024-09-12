load Rails.root.join("app", "models", "abilities", "administrator.rb")

class Abilities::Administrator
  alias_method :consul_initialize, :initialize

  def initialize(user)
    consul_initialize(user)

    can :download, ::Administrator
    can :download, Legislation::Process
    can :read, Audit
    can :manage, Cookies::Vendor
  end
end
