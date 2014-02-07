require 'spec_helper'

describe GoogleBooksHelper do

  include Devise::TestHelpers

  def blacklight_config
    @config ||= Blacklight::Configuration.new.configure do |config|
      config.show.heading = Solrizer.solr_name("heading", :displayable)
    end
  end

  def marc_document document = Hash.new
    Solrizer.insert_field(document, "isbn", "1888602392", :displayable)
    return document
  end

  before :all do
    WebMock.enable!
  end
      
  after :all do
    WebMock.disable!
  end

  before :each do
    helper.stub(:blacklight_config => blacklight_config)
  end

  describe "#image_link_from_isbn" do
    it "should return a link to an image" do
      stub_request(:get, "https://www.googleapis.com/books/v1/volumes?country=&maxResults=5&q=%7B:isbn=%3E%221888602392%22%7D&startIndex=0").
         to_return(:status => 200, :body => "", :headers => {})
      assign :document, marc_document
      expect(helper.image_link_from_isbn).to include "1888602392"
    end
  end

end
