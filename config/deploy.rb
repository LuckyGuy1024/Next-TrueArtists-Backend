# frozen_string_literal: true
lock '~> 3.14.1'

set :ssh_options, {
  forward_agent: true,
  user: 'admin',
  port: 8389
}

set :deploy_user, 'admin'
set :use_sudo, false
set :rails_env, 'production'

set :pty, true
set :copy_exclude, [".git"]
set :stages, %w(staging production)
set :default_stage, "staging"
set :default_shell, '/bin/bash -l'
# set :sidekiq_default_hooks, false

SSHKit.config.command_map[:sidekiq] = "bundle exec sidekiq"
SSHKit.config.command_map[:sidekiqctl] = "bundle exec sidekiqctl"

set :whenever_identifier, ->{ "#{fetch(:worker)}_#{fetch(:stage)}" }

set :application, "trueartists"
set :repo_url, "git@github.com:jwachira/trueartists.git"
set :deploy_to, "/var/www/apps/#{fetch(:application)}"
set :migration_role, :db
set :conditionally_migrate, true

ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

set :keep_releases, 5

set :linked_files, fetch(:linked_files, []).push('config/database.yml',
  'config/storage.yml',
  'config/application.yml'
)
append :linked_files,
  'config/database.yml',
  'config/storage.yml'
  'config/application.yml'

set :linked_dirs, fetch(:linked_dirs, []).push(
  'tmp/pids',
  'tmp/cache',
  'tmp/sockets',
  'vendor/bundle',
  'bundle',
  'log'
)

set :keep_releases, 2

set :rollbar_token, 'bf76b421739a47288ce7eefbcaafd9aa'
set :rollbar_env, Proc.new { fetch :stage }
set :rollbar_role, Proc.new { :app }

set :passenger_restart_with_touch, true
set :passenger_restart_options, -> { "#{deploy_to} --ignore-app-not-running --rolling-restart" }

set :rvm_ruby_version, '2.7.1@271'
# set :bundle_flags, '--deployment'
set :maintenance_roles, -> { roles([:web]) }
set :maintenance_template_path, File.expand_path("../../app/views/layouts/maintenance.html.erb", __FILE__)
set :maintenance_dirname, -> { "#{current_path}/public/system" }
# after 'deploy:updated', 'webpacker:precompile'
# before "webpacker:precompile", "deploy:yarn_install"
before "deploy:assets:precompile", "deploy:yarn_install"
namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end
