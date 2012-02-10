source :rubygems

group :test do
  gem 'fabrication',                    :require => false
  gem 'guard-rspec',                    :require => false
  gem 'guard-spork',                    :require => false
  gem 'libnotify'
  gem 'rb-inotify'
  gem 'rspec-rails',                    :require => false
  gem 'spork',                          :require => false
  gem 'sqlite3',                        :require => false
  gem 'shoulda-matchers',               :require => false
end

group :development do
  gem 'rails-dev-boost'
  gem 'annotate',     '>= 2.4.1.beta1', :require => false
end

group :production do
  gem 'fog',                            :require => false
  gem 'pg',                             :require => false
  gem 'unicorn',                        :require => false                   unless ENV['SHARED_DATABASE_URL']
end

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'therubyracer'                                                        unless RUBY_PLATFORM =~ /freebsd/
  gem 'uglifier'
end

gem 'acts_as_singleton'
gem 'ancestry'
gem 'configliere'
gem 'default_value_for'
gem 'dragonfly'
gem 'jquery-rails'
gem 'rails',                            :require => false
gem 'russian'
