rails_env = ENV['RAILS_ENV'] || "production"
environment rails_env

if rails_env == "production"
  pp "===IN PRODUCTION MODE==="
  # Change to match your CPU core count
  workers ENV.fetch("PUMA_MAX_WORKERS", 2)

  # Min and Max threads per worker
  max_threads_count = ENV.fetch("RAILS_MAX_THREADS", 5)
  min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
  threads min_threads_count, max_threads_count

  app_dir = File.expand_path("../..", __FILE__)
  shared_dir = "#{app_dir}/shared"

  # Default to production
  rails_env = ENV['RAILS_ENV'] || "production"
  environment rails_env

  # Set up socket location
  bind "unix://#{shared_dir}/sockets/puma.sock"

  # Logging
  stdout_redirect "#{shared_dir}/log/puma.stdout.log", "#{shared_dir}/log/puma.stderr.log", true

  # Set master PID and state locations
  pidfile "#{shared_dir}/pids/puma.pid"
  state_path "#{shared_dir}/pids/puma.state"
  activate_control_app

  on_worker_boot do
    require "active_record"
    ActiveRecord::Base.connection.disconnect! rescue ActiveRecord::ConnectionNotEstablished
    ActiveRecord::Base.establish_connection(YAML.load_file("#{app_dir}/config/database.yml")[rails_env])
  end
else
  pp "===IN DEVELOPMENT MODE==="

  threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }.to_i
  threads threads_count, threads_count

  # Specifies the `port` that Puma will listen on to receive requests, default is 3000.
  #
  port        ENV.fetch("PORT") { 3000 }

  plugin :tmp_restart
end

