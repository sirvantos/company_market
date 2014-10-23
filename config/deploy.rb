SSHKit.config.command_map[:rake] = "bundle exec rake"

# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'company_market'
set :repo_url, 'https://github.com/sirvantos/company_market.git'

# We are only going to use a single stage: production
set :stages, ["production"]

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :use_sudo, false

set :deploy_via, :copy

set :ssh_options, { :forward_agent => true, :port => 4321 }

set :keep_releases, 5

set :workers, { "mail" => 1 }

set :resque_environment_task, true

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
# set :keep_releases, 5

namespace :foreman do
  desc "Export the Procfile to Ubuntu's upstart scripts"
  task :export do
    on roles(:app), in: :sequence, wait: 5 do
      execute "cp /home/ruby_admin/www/company_market.com/shared/deploy/.env /home/ruby_admin/www/company_market.com/current"
      # execute "source /home/ruby_admin/www/company_market.com/shared/deploy/wrapper"
      execute "source /home/ruby_admin/www/company_market.com/shared/deploy/wrapper && cd /home/ruby_admin/www/company_market.com/current && foreman export upstart /home/ruby_admin/www/company_market.com/shared/deploy/init -a company_market -u ruby_admin"
      execute "sudo mv -f /home/ruby_admin/www/company_market.com/shared/deploy/init/*.conf /etc/init"
    end
  end

  desc "Start the application services"
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo start company_market"
    end
  end

  desc "Stop the application services"
  task :stop do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo stop company_market"
    end
  end

  desc "Restart the application services"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute "sudo start company_market || sudo restart company_market"
    end
  end
end

namespace :deploy do

  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      # execute :touch, release_path.join('tmp/restart.txt')
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
  after :published, "foreman:export"
  after :published, "foreman:restart"

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end
end