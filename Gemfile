source 'http://rubygems.org'

group :assets do
  gem 'sass-rails'
  gem 'therubyracer'                                                        unless RUBY_PLATFORM =~ /freebsd/
  gem 'uglifier'
end

group :default do
  gem 'ancestry'
  gem 'bunny',                          :require => false
  gem 'dragonfly'
  gem 'esp-commons'
  gem 'inherited_resources'
  gem 'jquery-rails'
  gem 'rails',                          :require => false
  gem 'russian'
end

group :development do
  gem 'annotate',     '>= 2.4.1.beta1', :require => false
  gem 'brakeman'
  gem 'rvm-capistrano'
end

group :production do
  gem 'fog',                            :require => false                   unless RUBY_PLATFORM =~ /freebsd/
  gem 'pg',                             :require => false
end

group :test do
  gem 'fabrication',                    :require => false
  gem 'guard-rspec',                    :require => false
  gem 'guard-spork',                    :require => false
  gem 'libnotify'
  gem 'moqueue',                        :require => false
  gem 'rb-inotify'
  gem 'rspec-rails',                    :require => false
  gem 'spork',                          :require => false
  gem 'sqlite3',                        :require => false
  gem 'shoulda-matchers',               :require => false
end
