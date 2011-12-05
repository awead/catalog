source 'http://rubygems.org'

gem 'rails', '3.1.3'

gem 'blacklight'

# Bundle edge Rails instead:
# gem 'rails',     :git => 'git://github.com/rails/rails.git'
gem 'sqlite3'
gem 'sanitize'
gem 'json'
gem 'rsolr', '=1.0.2'

# Asset pipeline is disabled for now
#
# Gems used only for assets and not required
# in production environments by default.
#group :assets do
#  gem 'sass-rails', "  ~> 3.1.0"
#  gem 'coffee-rails', "~> 3.1.0"
#  gem 'uglifier'
#end

gem 'jquery-rails'
gem 'rspec-rails'

# Use unicorn as the web server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'ruby-debug'

gem "devise"
gem "blacklight_highlight", :git => "git://github.com/awead/blacklight_highlight.git"

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
