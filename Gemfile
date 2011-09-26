source "http://rubygems.org"

gemspec

group :development, :test do
  gem 'rb-fsevent',                 :require => false if RUBY_PLATFORM =~ /darwin/i
  gem "growl_notify", "~> 0.0.1",   :require => false if RUBY_PLATFORM =~ /darwin/i
end
