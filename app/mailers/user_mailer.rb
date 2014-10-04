class UserMailer < BaseMailer
  default template_path: 'shared/mailer/user'

  def account_confirmation(auth)
    @auth = auth
    mail(to: @auth.user.email, subject: 'Account confirmation')
  end

  def restore_password(auth)
    @auth = auth
    mail(to: @auth.user.email, subject: 'Restore password')
  end
end
