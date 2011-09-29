ENV["RAILS_ENV"] = "test"

require File.expand_path("../dummy/config/environment.rb", __FILE__)
require 'rspec/rails'
require 'capybara/rspec'
require 'support/vcr'

Rails.backtrace_cleaner.remove_silencers!

VCR.config do |c|
  c.cassette_library_dir = 'spec/support/files/fixtures'
  c.stub_with :fakeweb
end

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

RSpec.configure do |config|
  config.extend VCR::RSpec::Macros

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

# helper methods

def support_file(name)
  File.expand_path("spec/support/files/#{name}")
end
