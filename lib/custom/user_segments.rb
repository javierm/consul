require_dependency Rails.root.join('lib', 'user_segments').to_s
class UserSegments
  require 'csv'
  SEGMENTS = %w(all_users
                administrators
                proposal_authors
                investment_authors
                feasible_and_undecided_investment_authors
                selected_investment_authors
                winner_investment_authors
                not_supported_on_current_budget
                newsletter_users_list)

  def self.to_csv
    CSV.generate(headers: true) do |csv|
      csv << headers
      UserSegments.all_users.each { |user| csv << csv_values(user) }
    end
  end

  private

  def self.headers
    [
      I18n.t("admin.newsletters.csv.id"),
      I18n.t("admin.newsletters.csv.email"),
      I18n.t("admin.newsletters.csv.state_created"),
      I18n.t("admin.newsletters.csv.state"),
      I18n.t("admin.newsletters.csv.confirmed"),
      I18n.t("admin.newsletters.csv.phone_and_home"),
      I18n.t("admin.newsletters.csv.confirmed_phone"),
      I18n.t("admin.newsletters.csv.n_iniciativas")
    ]
  end

  def self.csv_values(user)
    [
      user.id.to_s,
      user.email.to_s,
      user.created_at.to_s,
      user_state(user),
      user.confirmed?,
      user.residence_verified?,
      user.sms_verified?,     
      user.proposals.count.to_s
    ]
  end

  def self.user_state(u)
    if u.sms_verified?
      traduct("admin.newsletters.csv.state_residence_and_phone")
        elsif u.residence_verified?
          traduct("admin.newsletters.csv.state_residence")
        elsif u.confirmed?
          traduct("admin.newsletters.csv.state_email")
        elsif u.created_at?
          traduct("admin.newsletters.csv.state_created")
    end
  end

  def self.traduct(s)
    I18n.t(s)
  end
end
