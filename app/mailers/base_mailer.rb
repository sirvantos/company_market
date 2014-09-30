class BaseMailer < ActionMailer::Base
	default from: ENV['MAIL_FROM'] || "noreply@companymarket.com"
  default template_path: 'shared/mailer'
end