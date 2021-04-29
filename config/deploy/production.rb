# frozen_string_literal: true

server '192.81.134.189', user: fetch(:deploy_user), roles: %i[app web db], primary: true, port: 8389
set :stage, :production
set :sidekiq_default_hooks, false
set :sidekiq_role, :sidekiq
set :sidekiq_env, 'production'
set :sidekiq_roles, [:sidekiq]
set :sidekiq_config, "#{fetch(:deploy_to)}/current/config/sidekiq.yml"
set :assets_roles, %i[web sidekiq assets]

set :whenever_environment, -> { fetch(:rails_env) }
set :whenever_identifier,  -> { "#{fetch(:application)}_#{fetch(:stage)}" }
set :whenever_command,     -> { "cd #{fetch(:release_path)} && bundle exec whenever" }
