require 'rubygems'
require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] ||= 'test'
  require File.expand_path("../../config/environment", __FILE__)
  require 'rspec/rails'
  require 'shoulda/matchers'
  require 'fabrication'

  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

  RSpec.configure do |config|
    config.include Helper
    config.mock_with :rspec
    config.use_transactional_fixtures = true

    config.before { MessageMaker.stub(:make_message) }

    config.after(:all) do
      FileUtils.rm_rf(Dragonfly[:storage].datastore.root_path)
    end
  end

  ActiveSupport::Dependencies.clear
end

Spork.each_run do
end
