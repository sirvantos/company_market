web: bundle exec unicorn_rails -p $PORT -c ./config/unicorn.rb

resque-pool: env TERM_CHILD=1 RESQUE_TERM_TIMEOUT=7 bundle exec resque-pool