class Admin::EmailsDownloadController < Admin::BaseController
  def index
  end

  def generate_csv
    users_segment = params[:users_segment]
    filename = t("admin.segment_recipient.#{users_segment}")
    case users_segment
      when  'newsletter_users_list'
        csv_file = newsletter_users_list_csv
      else            
        csv_file = users_segment_emails_csv(users_segment)
      end
    send_data csv_file, filename: "#{filename}.csv"
  end

  private

  def users_segment_emails_csv(users_segment)
    UserSegments.user_segment_emails(users_segment).join(',')
  end
  
  def newsletter_users_list_csv
    UserSegments.to_csv
  end

end
