# config valid for current version and patch releases of Capistrano
lock "~> 3.17.1"

set :application, 'backend'
set :deploy_user, 'deploy'

# setup repo details
set :repo_url, 'git@github.com:njmbb8/Shai-Backend.git'

# setup rbenv.
set :rbenv_type, :system
set :rbenv_ruby, '3.1.3'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}

# setup certbot for SSL via letsencrypt
set :certbot_enable_ssl, true
set :certbot_redirect_to_https, true
set :certbot_email, "noreply@shaiprinceart.com"
set :certbot_use_acme_staging, false

# setup puma to operate in clustered mode, required for zero downtime deploys
set :puma_preload_app, false
set :puma_init_active_record, true
set :puma_workers, 3
set :puma_systemctl_user, fetch(:deploy_user)
set :puma_enable_lingering, true


set :sidekiq_systemctl_user, fetch(:deploy_user)
set :sidekiq_enable_lingering, true


# how many old releases do we want to keep
set :keep_releases, 5

# Directories that should be linked to the shared folder
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', '.bundle', 'public/system', 'public/uploads'
append :linked_files, 'config/database.yml', 'config/master.key'

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

namespace :deploy do
end
