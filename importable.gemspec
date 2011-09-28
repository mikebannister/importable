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
  s.add_dependency "carrierwave", "~> 0.5.7"
  # roo + dependencies (not bundled automatically)
  s.add_dependency "roo", "~> 1.9.7"
  s.add_dependency "rubyzip2", "~> 2.0.1"
  s.add_dependency "spreadsheet", "~> 0.6.5.9"
  s.add_dependency "google-spreadsheet-ruby", "~> 0.1.5"

  s.add_development_dependency "sqlite3", "~> 1.3.4"
  s.add_development_dependency "rspec-rails", "~> 2.6.1"
  s.add_development_dependency "capybara", "~> 1.1.1"
  s.add_development_dependency "launchy", "~> 2.0.5"
  s.add_development_dependency "mocha", "~> 0.10.0"
  s.add_development_dependency "fakeweb", "~> 1.3.0"
  s.add_development_dependency "guard-rspec", "~> 0.4.5"
end
