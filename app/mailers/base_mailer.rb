class BaseMailer < ActionMailer::Base
	default from: ENV['MAIL_FROM'] || "from@example.com"
  default template_path: 'shared/mailer'
end