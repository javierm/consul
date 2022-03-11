# disable SMS validation
class Verification::SmsController < ApplicationController
  before_action :authenticate_user!
  skip_authorization_check

  def new
    redirect_to account_path
  end

  alias_method :create, :new
  alias_method :edit, :new
  alias_method :update, :new
end
