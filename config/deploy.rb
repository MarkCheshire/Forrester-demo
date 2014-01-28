require "bundler/capistrano"

set :application, "cheshire"
set :user,"azureuser"

set :scm, :git
set :repository, "git@github.com:MarkCheshire/Forrester-demo.git"
set :branch, "master"
set :use_sudo, false

server "cheshire.cloudapp.net", :web, :app, :db, primary: true

set :deploy_to, "/home/#{user}/apps/#{application}"
default_run_options[:pty] = true
ssh_options[:forward_agent] = false
ssh_options[:port] = 22
ssh_options[:keys] = ["/home/mint/.ssh/markazure.key"]


namespace :deploy do
  task :start, :roles => [:web, :app] do
    run "cd #{deploy_to}/current && nohup bundle exec thin start -C config/production_config.yml -R config.ru"
    sudo "/usr/local/nginx/nginx/sbin/nginx -p /usr/local/nginx/nginx/ -c /usr/local/nginx/nginx.conf"
  end

  task :stop, :roles => [:web, :app] do
    run "kill -QUIT cat /usr/local/nginx/nginx/logs/nginx.pid"
    run "cd #{deploy_to}/current && nohup bundle exec thin stop -C config/production_config.yml -R config.ru"
  end

  task :restart, :roles => [:web, :app] do
    deploy.stop
    deploy.start
  end

  task :setup_config, roles: :app do
    sudo "ln -nfs #{current_path}/config/nginx.conf /usr/local/nginx/nginx.conf"
    sudo "ln -nfs #{current_path}/config/lua_tmp.lua /usr/local/nginx/lua_tmp.lua"
    sudo "mkdir -p #{shared_path}/config"
  end
  after "deploy:setup", "deploy:setup_config"

  # This will make sure that Capistrano doesn't try to run rake:migrate (this is not a Rails project!)
  task :cold do
    deploy.update
    deploy.start
  end
end