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
    config.mock_with :mocha
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

# helpers

def override_import_templates(model, &block)
  # figure out paths
  root_path = File.join(Rails.root, 'app/views', model)
  template_root_path = File.join(root_path, 'importable/spreadsheets')
  template_path = File.join(template_root_path, 'new.html.erb')

  # make dirs and file
  FileUtils.mkdir_p template_root_path
  FileUtils.touch template_path

  # add some content that we can check for
  File.open(template_path, 'w') { |file| file.write("#{model} content") }
  
  yield

  # cleanup
  FileUtils.rm_rf root_path
end
