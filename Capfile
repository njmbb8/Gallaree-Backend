# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"

# Load the SCM plugin appropriate to your project:
#
# require "capistrano/scm/hg"
# install_plugin Capistrano::SCM::Hg
# or
# require "capistrano/scm/svn"
# install_plugin Capistrano::SCM::Svn
# or
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include tasks from other gems included in your Gemfile
#
# For documentation on these, see for example:
#
#   https://github.com/capistrano/rbenv
#   https://github.com/capistrano/bundler
#   https://github.com/capistrano/rails
#
require "capistrano/rbenv"
require "capistrano/bundler"
require "capistrano/rails/assets"
require "capistrano/rails/migrations"
require 'capistrano/cookbook'

require 'capistrano/puma'
install_plugin Capistrano::Puma, load_hooks: false  # Default puma tasks
install_plugin Capistrano::Puma::Nginx, load_hooks: false   # if you want to upload a nginx site template
install_plugin Capistrano::Puma::Systemd, load_hooks: false # if you use SystemD 
install_plugin Capistrano::Puma::Monit, load_hooks: false  # if you need the monit tasks


require 'capistrano/sidekiq'
install_plugin Capistrano::Sidekiq  # Default sidekiq tasks
# Then select your service manager
install_plugin Capistrano::Sidekiq::Systemd 


# Load custom tasks from `lib/capistrano/tasks` if you have any defined
Dir.glob("lib/capistrano/tasks/*.rake").each { |r| import r }
