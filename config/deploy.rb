require 'bundler/capistrano'
load 'deploy/assets'

set :application, "www"

set :scm, :git
set :git_enable_submodules, true

set :user, 'ubuntu'
set :use_sudo, false
set :branch, 'master'
set :repository,  "ssh://git@git.adamhooper.com/home/git/www.git"
set :deploy_via, :remote_cache
set :deploy_to, "/opt/rails/#{application}"
set :keep_releases, 5

role :app, "amazon"
role :web, "amazon"
role :db, "amazon", :primary => true

ssh_options[:keys] = "#{ENV['home']}/.ssh/adamhooper-on-amazon-id_rsa"
ssh_options[:forward_agent] = true

default_run_options[:pty] = true

namespace :deploy do
  desc "Does not start the server (we use Passenger)"
  task :start, :roles => :app do
  end

  desc "Does not stop the server (we use Passenger)"
  task :stop, :roles => :app do
  end

  desc "Restarts the server (touching a file -- we use Passenger)"
  task :restart, :roles => :app do
    run %(touch #{latest_release}/tmp/restart.txt)
  end

  desc "Fixes permissions and updates symlinks"
  task :after_update_code, :roles => :app do
    sudo %(chown www-data:www-data #{latest_release}/config/environment.rb)
    run "ln -nfs #{shared_path}/config/admin-password #{release_path}/config/admin-password" 
  end
end

after "deploy:update_code", "db:symlink" 

namespace :db do
  desc "Create symlink to the real database" 
  task :symlink do
    run "touch #{shared_path}/database/production.sqlite3" # if it doesn't exist, create empty database
    run "ln -nfs #{shared_path}/database/production.sqlite3 #{release_path}/database/production.sqlite3"
  end
end
