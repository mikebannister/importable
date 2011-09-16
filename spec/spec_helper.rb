require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"

  require File.expand_path("../dummy/config/environment.rb", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'

  Rails.backtrace_cleaner.remove_silencers!

  # Load support files
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :rspec
    config.use_transactional_fixtures = false
  end

  def support_file(name)
    File.expand_path("spec/support/#{name}")
  end
end

Spork.each_run do
  if Spork.using_spork?
    load 'Sporkfile' if File.exists? "Sporkfile"
  end
   
  Dummy::Application.reload_routes!
end
