# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

# role :app, %w{deploy@example.com}
# role :web, %w{deploy@example.com}
# role :db,  %w{deploy@example.com}

set :application, 'staging_company_market'
set :rails_env, "staging"
set :branch, 'develop'
set :deploy_to, '/home/ruby_admin/www/staging.company_market.com/'
set :default_env, {
    'DEFAULT_HOST' => 'staging.company_market.com',
    'SECRET_TOKEN' => 'mysuperhellotesttesthello',
    'RAILS_ENV' => 'staging',
    'MAIL_FROM' => 'from@company_market.com',
    'TIME_ZONE' => 'Berlin',
    'RESQUE_LOG_ON' => 1,
    'REDISCLOUD_URL' => 'redis://127.0.0.1:6379',
    'RAKE_ENV' => 'staging'
}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server definition into the
# server list. The second argument is a, or duck-types, Hash and is
# used to set extended properties on the server.

# server 'example.com', user: 'deploy', roles: %w{web app}, my_property: :my_value


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
