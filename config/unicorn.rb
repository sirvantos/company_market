# config/unicorn.rb
Rails.log.info('Disconnected from Redis')
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)

timeout 15

preload_app true

@resque_pid = nil

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  if defined?(ActiveRecord::Base)
    ActiveRecord::Base.connection.disconnect!
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    # USE HIS LINE ONLY FOR SINGLE DYNO HEROKU CONFIGURATION
    @resque_pid ||= spawn("bundle exec rake resque:work")
    Resque.redis.quit
    Rails.logger.info('Disconnected from Redis')
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  # other settings
  if defined?(ActiveRecord::Base)
    config = ActiveRecord::Base.configurations[Rails.env] ||
        Rails.application.config.database_configuration[Rails.env]
    config['reaping_frequency'] = ENV['DB_REAP_FREQ'] || 10 # seconds
    config['pool']            =   ENV['DB_POOL'] || 2
    ActiveRecord::Base.establish_connection(config)
  end

  # If you are using Redis but not Resque, change this
  if defined?(Resque)
    Resque.redis = ENV["REDISCLOUD_URL"]
    Rails.logger.info('Connected to Redis')
  end
end