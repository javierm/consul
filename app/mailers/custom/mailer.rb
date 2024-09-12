load Rails.root.join("app", "mailers", "mailer.rb")

class Mailer
  def contact(subject, intro, message)
    @message = message
    @intro = intro
    @email_to = Rails.application.secrets.contact_email

    I18n.with_locale(Setting.default_locale) do
      mail(to: @email_to, subject: subject)
    end
  end
end
