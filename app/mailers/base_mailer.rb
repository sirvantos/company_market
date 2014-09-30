class BaseMailer < ActionMailer::Base
	default from: "from@example.com"
  default template_path: 'shared/mailer'
end