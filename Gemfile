source :rubygems

group :assets do
  gem 'coffee-rails'
  gem 'sass-rails'
  gem 'therubyracer'                                                        unless RUBY_PLATFORM =~ /freebsd/
  gem 'uglifier'
end

group :default do
  gem 'ancestry'
  gem 'dragonfly'
  gem 'esp-commons'
  gem 'russian'
  gem 'jquery-rails'
  gem 'rails',                          :require => false
end

group :development do
  gem 'annotate',     '>= 2.4.1.beta1', :require => false
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
  gem 'rb-inotify'
  gem 'rspec-rails',                    :require => false
  gem 'spork',                          :require => false
  gem 'sqlite3',                        :require => false
  gem 'shoulda-matchers',               :require => false
end

