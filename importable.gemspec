$:.push File.expand_path("../lib", __FILE__)
require "importable/version"

Gem::Specification.new do |s|
  s.name        = "importable"
  s.version     = Importable::VERSION
  s.authors     = ["Mike Bannister"]
  s.email       = ["mikebannister@gmail.com"]
  s.homepage    = "https://github.com/mikebannister/importable"
  s.summary     = "Import spreadsheets and map data to rails models, easily."
  s.description = "Import spreadsheets and map data to rails models, easily."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency "rails", "~> 3.1.0"
  s.add_dependency "carrierwave"
  # roo and it's dependencies (currently they aren't bundled automatically)
  s.add_dependency 'roo'
  s.add_dependency 'rubyzip2'
  s.add_dependency 'spreadsheet'
  s.add_dependency 'google-spreadsheet-ruby'

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "capybara"
  s.add_development_dependency "launchy"
  s.add_development_dependency "spork"
end
