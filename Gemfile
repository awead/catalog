source 'http://rubygems.org'

gem 'rails', '3.2.1'
gem 'sass-rails', "  ~> 3.2.3"

gem 'blacklight'
gem 'sqlite3'
gem 'sanitize'
gem 'json'
gem 'jquery-rails'
gem 'rspec-rails'
gem "devise"
gem "blacklight_highlight"

group :assets do
  gem 'coffee-rails', "~> 3.2.1"
  gem 'uglifier', '>= 1.0.3'
end

# Bundle gems for the local environment. Make sure to
# put test-only gems in this group so their generators
# and rake tasks are available in development mode:
group :development, :test do
  gem 'webrat'
  gem 'cucumber'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'capybara'
end

group :cucumber do
  gem 'capybara'
  gem 'database_cleaner'
  gem 'cucumber-rails'
  gem 'cucumber'
  gem 'spork'
  gem 'launchy'    # So you can do Then show me the page
end
