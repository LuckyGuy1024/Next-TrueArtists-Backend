set :ssh_options, {
  forward_agent: true,
  user: 'admin',
  port: 8389
}

set :rails_env, 'staging'
set :domain, 'qa.trueartists.com'
server fetch(:domain), user: fetch(:deploy_user), roles: [:app, :db, :sidekiq, :worker], primary: true, port: 8389
set :stage, :staging
set :sidekiq_default_hooks, true
set :sidekiq_role, :sidekiq
set :sidekiq_env, 'staging'
set :sidekiq_roles, [:sidekiq]
set :sidekiq_config, "#{fetch(:deploy_to)}/current/config/sidekiq.yml"
set :assets_roles, [:web, :sidekiq, :assets]
set :deploy_to, "/var/www/apps/#{fetch(:application)}"
