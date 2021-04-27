module Custom::AdminHelper
  def menu_budgets?
    controller_name.starts_with?("budget") && controller_name != "budget_managers"
  end

  def menu_profiles?
    %w[administrators organizations officials moderators valuators managers users legislators budget_managers].include?(controller_name)
  end
end
