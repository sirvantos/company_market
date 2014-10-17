# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

set :rails_env, "production"
set :branch, 'master'
set :deploy_to, '/home/ruby_admin/www/company_market.com'
set :default_env, {
	'SECRET_TOKEN' => 'mysuperhellotesttesthello',
	'RAILS_ENV' => 'production',
	'MAIL_FROM' => 'from@company_market.com',
	'TIME_ZONE' => 'Berlin',
	'RESQUE_LOG_ON' => 1,
	'REDISCLOUD_URL' => 'redis://127.0.0.1:6379',
	'RAKE_ENV' => 'production'
}

# Specify the server that Resque will be deployed on. If you are using Cap v3
# and have multiple stages with different Resque requirements for each, then
# these __must__ be set inside of the applicable config/deploy/... stage files
# instead of config/deploy.rb:
role :resque_worker, "www.company_market.com"

# server "192.168.56.2", :app, :web, :db, :primary => true

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}


# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value
server "192.168.56.2", user: 'ruby_admin', roles: %w{app web db}

# Custom SSH Options
# ==================
# You may pass any option but keep in mind that net/ssh understands a
# limited set of options, consult[net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start).
#
# Global options
# --------------
#  set :ssh_options, {
#    keys: %w(/home/rlisowski/.ssh/id_rsa),
#    forward_agent: false,
#    auth_methods: %w(password)
#  }
#
# And/or per server (overrides global)
# ------------------------------------
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
