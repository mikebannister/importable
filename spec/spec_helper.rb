require 'spork'

Spork.prefork do
  ENV["RAILS_ENV"] = "test"

  require File.expand_path("../dummy/config/environment.rb", __FILE__)
  require 'rspec/rails'
  require 'capybara/rspec'
  require 'fakeweb'

  Rails.backtrace_cleaner.remove_silencers!

  # Load support files
  Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

  RSpec.configure do |config|
    config.mock_with :mocha
    config.use_transactional_fixtures = true
    
    # for spork
    config.treat_symbols_as_metadata_keys_with_true_values = true
    config.filter_run :focus => true
    config.run_all_when_everything_filtered = true

    config.before(:all) do
      DeferredGarbageCollection.start
    end

    config.after(:all) do
      DeferredGarbageCollection.reconsider
    end
  end
end

Spork.each_run do
  if Spork.using_spork?
    load 'spec/Sporkfile' if File.exists? 'spec/Sporkfile'
  end

  Spork.trap_method(Rails::Application::RoutesReloader, :reload!)   
end

# helper methods

def support_file(name)
  File.expand_path("spec/support/#{name}")
end

def all_fake_resources
  [
    {
      id: 1,
      foo_date: '2010-04-14'
    },
    {
      id: 2,
      foo_date: '2010-04-15'
    },
    {
      id: 3,
      foo_date: '2010-04-16'
    }
  ]
end

def range_fake_resources
  [
    {
      id: 1,
      foo_date: '2010-04-14'
    },
    {
      id: 2,
      foo_date: '2010-04-15'
    }
  ]
end

def single_fake_resource
  {
    id: 1,
    foo_date: '2010-04-14'
  }
end

def start_fake_foo_api
    FakeWeb.register_uri(:get,
                         "http://fake-foo-api.dev/foos.json",
                         :body => all_fake_resources.to_json)
    FakeWeb.register_uri(:get,
                         "http://fake-foo-api.dev/foos.json?end_date=2010-04-15&start_date=2010-04-14",
                         :body => range_fake_resources.to_json)
    FakeWeb.register_uri(:get,
                         "http://fake-foo-api.dev/foos/1.json",
                         :body => single_fake_resource.to_json)

    FakeWeb.allow_net_connect = false
end
