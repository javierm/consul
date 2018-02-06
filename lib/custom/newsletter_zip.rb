require_dependency Rails.root.join('lib', 'newsletter_zip').to_s

class NewsletterZip
  def emails
    User.newsletter.map do |u|
      [u.id, u.created_at, (u.email.presence || I18n.t('admin.newsletters.empty_email')),
       u.confirmed?, u.residence_verified?, u.sms_verified?, u.proposals.count].join(';')
    end.join("\n")
  end
end
