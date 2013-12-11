source 'http://rubygems.org'

gem 'rails', '~>3.2.15'

gem 'blacklight', '~> 3.8.2'
gem 'sqlite3'
gem 'sanitize'
gem 'json'
gem 'sass-rails'
gem 'devise', '< 3.0.0'
gem 'devise-guests'
gem 'blacklight_highlight'
gem 'blacklight-sitemap', :path=> 'gems/blacklight-sitemap'
gem 'ruby-ntlm'
gem 'solr_ead', '=0.4.5'
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
  gem 'selenium-webdriver'
  gem 'launchy'
end
