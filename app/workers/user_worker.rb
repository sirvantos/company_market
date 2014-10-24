class UserWorker
	@queue = :user

	def self.perform(params)
    Resque.logger.info('User data prepare to handle')
    #params are unserialized value, se we can not use :symbol keys
    case params["for"]
		 	when 'creation'
		 		user = User.new(params["user_params"])
        if user.save
          Resque.logger.info('User is created')
        else
          Resque.logger.info('User is not created')
        end
		 end
	end
end
