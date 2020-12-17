module Custom::UsersHelper
  def current_legislator?
    current_user&.legislator?
  end
end
