class Admin::Organizations::TableActionsComponent < ApplicationComponent
  attr_reader :organization
  delegate :can?, to: :controller

  def initialize(organization)
    @organization = organization
  end

  private

    def can_verify?
      can? :verify, organization
    end

    def can_reject?
      can? :reject, organization
    end
end
