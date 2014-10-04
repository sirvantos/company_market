class MailWorker
	@queue = :mail

	def self.perform(params)
    Resque.logger.info('Mail prepare to sent')
    #params are unserialized value, se we can not use :symbol keys
    case params["for"]
		 	when 'account_confirmation'
		 		UserMailer.account_confirmation(Authorization.find(params["auth_id"])).deliver
        Resque.logger.info('Mail is sent')
      when 'password_restore'
		 		auth = Authorization.find(params["auth_id"])
        auth.update_attributes(
            restore_password_hash: auth.generate_md5_hash, restore_password_hash_created: DateTime.now)

        UserMailer.restore_password(Authorization.find(params["auth_id"])).deliver
        Resque.logger.info('Mail is sent')
		 end
	end
end
