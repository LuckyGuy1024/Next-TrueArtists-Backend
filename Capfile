# frozen_string_literal: true

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails'
require 'capistrano/rails/db'
# require "capistrano/rails/migrations"
require 'capistrano/sidekiq'
require 'sshkit/sudo'
# require 'capistrano/passenger'
require 'rollbar/capistrano3'
require 'capistrano/maintenance'
# require "capistrano/webpacker/precompile"
# Load custom tasks from `lib/capistrano/tasks` if you have any defined
# require 'capistrano/puma'
# require "capistrano/puma-nginx"
require 'capistrano/puma'
install_plugin Capistrano::Puma, load_hooks: true

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
require 'whenever/capistrano'
