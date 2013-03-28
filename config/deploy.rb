require 'rvm/capistrano'
require "bundler/capistrano"

set :rvm_ruby_string, '1.9.3'
set :rvm_type, :user

set :application, "terminator"

set :repository, "."
set :scm, :none
set :scm_username, "zheng.cuizh@gmail.com"
set :keep_releases, 5   # 留下多少个版本的源代码
set :deploy_via, :copy
set :deploy_to, "/home/www/terminator"

# set :scm, :git # You can set :scm explicitly or Capistrano will make an intelligent guess based on known version control directory names
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

role :web, ""                          # Your HTTP server, Apache/etc
role :app, ""                          # This may be the same as your `Web` server
role :db,  "", :primary => true # This is where Rails migrations will run

set :user, "www"
set :use_sudo, false
# if you want to clean up old releases on each deploy uncomment this:
after "deploy:restart", "deploy:cleanup"

default_run_options[:pty] = true 
ssh_options[:forward_agent] = true
ssh_options[:auth_methods] = %w(publickey)
ssh_options[:port] = 16677

namespace :deploy do
  task :start, :roles => :app do
    run "cd #{current_path};bundle exec thin start -C config/thin.yml"
  end
  task :restart, :roles => :app do   
	run "cd #{current_path};bundle exec kill -HUP `tail /home/www/rca.rc/current/tmp/pids/thin.*.pid | grep ^[0-9]`"
  end
  task :stop, :roles => :app do   
    run "cd #{current_path};bundle exec thin stop -C config/thin.yml"
  end
end

after 'deploy:update_code' do
  softlinks = [
    "rm -rf #{release_path}/tmp/sockets;ln -nfs #{deploy_to}/shared/sockets #{release_path}/tmp/sockets",
    "rm -rf #{release_path}/tmp/pids;ln -nfs #{deploy_to}/shared/pids #{release_path}/tmp/pids",
    "rm -rf #{release_path}/config/server.yml;ln -nfs #{deploy_to}/shared/system/server.yml #{release_path}/config/server.yml",
    "rm -rf #{release_path}/config/thin.yml;ln -nfs #{deploy_to}/shared/system/server.yml #{release_path}/config/thin.yml"
    ]
  run "#{softlinks.join(';')}"
end