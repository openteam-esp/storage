# OPENTEAM-specific deployment configuration

settings_yml_path = "config/deploy.yml"
config = YAML::load(File.open(settings_yml_path))
raise "not found deploy key in settings.yml. see settings.yml.example" unless config['deploy']
application = config['deploy']['openteam']["application"]
raise "not found deploy.application key in settings.yml. see settings.yml.example" unless application
domain = config['deploy']['openteam']["domain"]
raise "not found deploy.domain key in settings.yml. see settings.yml.example" unless domain
gateway = config['deploy']['openteam']["gateway"]
raise "not found deploy.gateway key in settings.yml. see settings.yml.example" unless gateway

set :stages, %w(tusur openteam)

set :application, application
set :domain, domain
set :gateway, gateway

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
