# Load environment vars
require 'figaro'
Figaro.application = Figaro::Application.new(
  environment: ENV.fetch('RAILS_ENV') { 'production' }, path: "config/application.yml")
Figaro.load

# Load DSL and set up stages
require 'capistrano/setup'
# Include default deployment tasks
require 'capistrano/deploy'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git


#require 'airbrake/capistrano3'

require 'sshkit/sudo'

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rvm
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/chruby
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#   https://github.com/capistrano/passenger
#
# require 'capistrano/rvm'
require 'capistrano/rbenv'
require 'capistrano/bundler'
# require 'capistrano/rails/assets'
require 'capistrano/rails/migrations'
# require 'capistrano/chruby'
# require 'capistrano/passenger'

require 'capistrano/sidekiq'
require 'capistrano/sidekiq/monit'

# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
Dir.glob('lib/capistrano/**/*.rb').each { |r| import r }
