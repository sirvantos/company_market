class UserMailer < BaseMailer
  default template_path: 'shared/mailer/user'

  def account_confirmation(auth)
    @auth = auth
    mail(to: @auth.user.email, subject: 'Welcome to My Awesome Site', from: "webmaster@example.com")
  end
end
