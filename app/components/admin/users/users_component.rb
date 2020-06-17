class Admin::Users::UsersComponent < ApplicationComponent
  attr_reader :users

  def initialize(users)
    @users = users
  end

  private

    def user_roles(user)
      roles = []
      roles << :admin if user.administrator?
      roles << :moderator if user.moderator?
      roles << :valuator if user.valuator?
      roles << :manager if user.manager?
      roles << :poll_officer if user.poll_officer?
      roles << :official if user.official?
      roles << :organization if user.organization?
      roles
    end
end
