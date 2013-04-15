source 'http://rubygems.org'

gem 'rails', '~>3.2.12'

gem 'blacklight', '< 4.0.0'
gem 'sqlite3'
gem 'sanitize'
gem 'json'
gem 'sass-rails'
gem 'devise'
gem 'devise-guests'
gem 'blacklight_highlight'
gem 'blacklight-sitemap', :git => 'git://github.com/awead/blacklight-sitemap.git'
gem 'ruby-ntlm'
gem 'solr_ead'
gem 'therubyracer'

# jQuery 1.9 breaks checkbox_submit.js functions
# using jquery-rails versions prior to 2.2 keeps us to jQuery 1.8
gem 'jquery-rails', '< 2.2.0'

group :assets do
  gem 'coffee-rails'
  gem 'uglifier'
  gem 'compass-rails'
  gem 'compass-susy-plugin', :require => 'susy'
end

group :development, :test do
  gem 'rspec-rails', '~> 2.12.2'
  gem 'webrat'
  gem 'database_cleaner'
  gem 'debugger'
  gem 'pry'
end

group :cucumber do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'
end

group :production do
  gem 'passenger', '=3.0.18'
end
