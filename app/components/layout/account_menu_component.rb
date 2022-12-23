class Layout::AccountMenuComponent < ApplicationComponent
  attr_reader :user
  delegate :multitenancy_management_mode?, to: :helpers

  def initialize(user)
    @user = user
  end
end
