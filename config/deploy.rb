set :application, 'www'
set :repo_url, 'file:///home/git/www.git'

# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

set :deploy_to, '/opt/rails/www'
set :scm, :git
set :branch, 'master'

set :format, :pretty
set :log_level, :debug
# set :pty, true

set :linked_files, %w{db/production.sqlite3 config/environments/production.rb config/admin-password}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/scratchpad}

# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :keep_releases, 5
