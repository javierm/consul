require_dependency Rails.root.join('app', 'mailers', 'mailer').to_s
class Mailer
  def email_verification_residence(recipient, failed)
    @recipient = recipient
    @failed = failed

    mail(to: @recipient, subject: t('mailers.email_verification_residence.subject'))
  end

  private

  def with_user(user, &block)
    I18n.with_locale(user.locale) do
      block.call
    end
  end
end
