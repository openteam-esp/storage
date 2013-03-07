settings_yml_path = "config/deploy.yml"
config = YAML::load(File.open(settings_yml_path))
raise "not found deploy key in deploy.yml. see deploy.yml.example" unless config['deploy']
application = config['deploy']['ato']["application"]
raise "not found deploy.application key in deploy.yml. see deploy.yml.example" unless application
domain = config['deploy']['ato']["domain"]
raise "not found deploy.domain key in deploy.yml. see deploy.yml.example" unless domain

set :application, application
set :domain, domain

set :ssh_options, { :forward_agent => true }

set :rails_env, "production"
set :deploy_to, "/srv/#{application}"
set :use_sudo, false
set :unicorn_instance_name, "unicorn"

set :scm, :git
set :repository, "git://github.com/openteam-esp/storage.git"
set :branch, "master"
set :deploy_via, :remote_cache

set :keep_releases, 7

set :bundle_gemfile,  "Gemfile"
set :bundle_dir,      File.join(fetch(:shared_path), 'bundle')
set :bundle_flags,    "--deployment --quiet --binstubs"
set :bundle_without,  [:development, :test]

role :web, domain
role :app, domain
role :db,  domain, :primary => true

namespace :deploy do
  desc "Copy config files"
  task :config_app, :roles => :app do
    run "ln -s #{deploy_to}/shared/config/settings.yml #{release_path}/config/settings.yml"
    run "ln -s #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end

  desc "Copy unicorn.rb file"
  task :copy_unicorn_config do
    run "mv #{deploy_to}/current/config/unicorn.rb #{deploy_to}/current/config/unicorn.rb.example"
    run "ln -s #{deploy_to}/shared/config/unicorn.rb #{deploy_to}/current/config/unicorn.rb"
  end

  desc "Symlink files directory"
  task :files do
    run "ln -s #{deploy_to}/shared/files/ #{deploy_to}/current/.files"
  end

  desc "Reload Unicorn"
  task :reload_servers do
    run "/usr/local/etc/rc.d/#{unicorn_instance_name} restart"
  end

  desc "Airbrake notify"
  task :airbrake do
    run "cd #{deploy_to}/current && RAILS_ENV=production TO=production bin/rake airbrake:deploy"
  end
end

namespace :unicorn do
  desc "Start Unicorn"
  task :start do
    run "/usr/local/etc/rc.d/unicorn start"
  end

  desc "Stop Unicorn"
  task :stop do
    run "/usr/local/etc/rc.d/unicorn stop"
  end

  desc "Reload Unicorn"
  task :reload do
    run "/usr/local/etc/rc.d/unicorn reload"
  end

  desc "Restart Unicorn"
  task :restart do
    run "/usr/local/etc/rc.d/unicorn restart"
  end
end

namespace :subscriber do
  desc "Start rabbitmq subscriber"
  task :start do
    run "#{deploy_to}/current/script/subscriber -e production start"
  end

  desc "Stop rabbitmq subscriber"
  task :stop do
    run "#{deploy_to}/current/script/subscriber stop"
  end
end

# stop subscribers
# before "deploy", "subscriber:stop"

# deploy
after "deploy:finalize_update", "deploy:config_app"
after "deploy", "deploy:migrate"
after "deploy", "deploy:copy_unicorn_config"
after "deploy", "deploy:files"
after "deploy", "unicorn:reload"
# after "deploy", "subscriber:start"
after "deploy:restart", "deploy:cleanup"
after "deploy", "deploy:airbrake"

# deploy:rollback
after "deploy:rollback", "unicorn:restart"
after "deploy:rollback", "subscriber:start"
