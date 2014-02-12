# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV["RAILS_ENV"] ||= 'test'
require File.expand_path("../../config/environment", __FILE__)
require 'rspec/rails'
require 'webmock/rspec'

# Requires supporting ruby files with custom matchers and macros, etc,
# in spec/support/ and its subdirectories.
Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}

RSpec.configure do |config|
  # == Mock Framework
  #
  # If you prefer to use mocha, flexmock or RR, uncomment the appropriate line:
  #
  # config.mock_with :mocha
  # config.mock_with :flexmock
  # config.mock_with :rr
  config.mock_with :rspec

  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  #config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = true

  # Webmock should only be enabled for certain tests
  WebMock.disable!
end

def ead_fixture file #:nodoc
  File.new(File.join(File.dirname(__FILE__), 'fixtures', 'ead', file))
end

def marc_fixture file #:nodoc
  MARC::Reader.new(File.join(File.dirname(__FILE__), 'fixtures', 'marc', file)).first
end

def webmock_fixture file
  File.new(File.join(File.dirname(__FILE__), 'fixtures', 'webmock', file))
end

def field_title_selector field
  "dt.blacklight-" + Solrizer.solr_name(field, :displayable)
end

def field_content_selector field
  "dd.blacklight-" + Solrizer.solr_name(field, :displayable)
end

def facet_selector field
  "div.blacklight-" + Solrizer.solr_name(field, :facetable)
end

  def execute_search terms, search_field=nil
    visit root_path
    fill_in "q", :with => terms
    select(search_field, :from => "search_field") unless search_field.nil?
    find_button("search").click
  end
