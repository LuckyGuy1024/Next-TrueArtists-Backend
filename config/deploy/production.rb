set :rails_env, 'production'
set :domain, '50.116.14.80'
server fetch(:domain), user: fetch(:deploy_user), roles: [:app, :db, :sidekiq, :worker], primary: true
set :stage, :production
set :sidekiq_default_hooks, true
set :sidekiq_role, :sidekiq
set :sidekiq_env, 'production'
set :sidekiq_roles, [:sidekiq]
set :sidekiq_config, "#{fetch(:deploy_to)}/current/config/sidekiq.yml"
set :assets_roles, [:web, :sidekiq, :assets]
set :deploy_to, "/var/www/apps/#{fetch(:application)}"

# Puma settings
set :puma_threads,    [1, 6]
set :puma_workers,    0
set :puma_bind,       "unix://#{shared_path}/tmp/sockets/#{fetch(:application)}-puma.sock"
set :puma_state,      "#{shared_path}/tmp/pids/puma.state"
set :puma_pid,        "#{shared_path}/tmp/pids/puma.pid"
set :puma_access_log, "#{release_path}/log/puma.access.log"
set :puma_error_log,  "#{release_path}/log/puma.error.log"
set :puma_preload_app, true
set :puma_worker_timeout, nil
set :puma_init_active_record, true # Change to false when not using ActiveRecord

set :whenever_identifier,  -> { "#{fetch(:application)}_#{fetch(:stage)}" }
