source 'https://rubygems.org'

# Use ActiveModel has_secure_password
gem 'bcrypt-ruby', '3.1.2'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.4'

# Use postgresql as the database for Active Record
gem 'pg'

# Use SCSS for stylesheets
gem 'sass-rails', '~> 4.0.2'

# Use SCSS for bootstrap stylesheets
gem 'bootstrap-sass', '~> 3.1.1'

# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'

# Use CoffeeScript for .js.coffee assets and views
gem 'coffee-rails', '~> 4.0.0'

# Use jquery as the JavaScript library
gem 'jquery-rails'

# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'

# secure headers tags
gem 'secure_headers'

# Gemfile
gem "rack-timeout"

# #queue
gem 'resque', "~> 1.25.2"
#multiprocessing queue
#gem 'resque-pool'

#strip model attributes
gem "strip_attributes"

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  #mail debug
  gem 'mailcatcher'
  #run unicorn server in development mode
  gem "unicorn-rails"
  gem 'guard-rspec', '2.5.0'
  gem 'rspec-rails', '2.13.1'
  gem 'spork-rails', '4.0.0'
  gem 'guard-spork', '1.5.0'
  gem 'childprocess', '0.5.3'
  #datapopulation
  # heroku deployer
  gem 'heroku_san'
end

group :test do
  gem 'selenium-webdriver', '~> 2.35.1'
  gem 'capybara', '~> 2.1.0'
  gem 'factory_girl_rails', '~> 4.2.1'
  gem 'cucumber-rails', '~> 1.4.0', :require => false
  gem 'database_cleaner', github: 'bmabey/database_cleaner'
  gem 'libnotify', '~> 0.8.0'
  gem 'nokogiri', '~> 1.3'
  gem 'rack_session_access'
  #datapopulation
end

group :production do
  #run unicorn server in production mode
  gem 'unicorn'
  gem 'rails_12factor'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]