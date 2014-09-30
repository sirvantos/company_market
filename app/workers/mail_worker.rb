class MailWorker
	@queue = :mail

	def self.perform(params)
    Resque.logger.info('Mail prepare to sent')
    #params are unserialized value, se we can not use :symbol keys
    case params["for"]
		 	when "account_confirmation"
		 		UserMailer.account_confirmation(Authorization.find(params["auth_id"])).deliver
        Resque.logger.info('Mail is sent')
		 end
	end
end
