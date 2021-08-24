# frozen_string_literal: true

# Load DSL and set up stages
require 'capistrano/setup'

# Include default deployment tasks
require 'capistrano/deploy'

require 'capistrano/scm/git'
install_plugin Capistrano::SCM::Git

require 'capistrano/rvm'
require 'capistrano/bundler'
require 'capistrano/rails/db'
require 'capistrano/rails/assets'
require 'capistrano/sidekiq'
require 'sshkit/sudo'
require 'rollbar/capistrano3'
require 'capistrano/maintenance'
require 'capistrano/puma'
require 'capistrano/rails/migrations'

install_plugin Capistrano::Puma, load_hooks: true
install_plugin Capistrano::Puma::Systemd

Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
