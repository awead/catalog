require "spec_helper"

describe BlacklightHelper do

  include ERB::Util
  include BlacklightHelper
  include Devise::TestHelpers
  def blacklight_config
    @config ||= Blacklight::Configuration.new.configure do |config|
      config.index.title_field = "title_display"
      config.index.display_type_field = "format"
      config.show.title_field = Solrizer.solr_name("heading", :displayable)
    end
  end

  before(:each) do
    helper.stub(:search_action_url) do |*args|
      catalog_index_url *args
    end
  end

  describe "#render_field_value" do
    it "should join and html-safe values" do
      expect(helper.render_field_value(["a", "b"])).to eq "a<br/>b"
    end
  end

  describe "#link_back_to_catalog" do
    before(:all) do
      @query_params = {:q => "query", :f => "facets", :per_page => "10", :page => "2", :controller=>"catalog"}
      @bookmarks_query_params = { :page => "2", :controller=>"bookmarks"}
    end

    it "should build a link tag to catalog using session[:search] for query params" do
      helper.stub(:current_search_session).and_return double(:query_params => @query_params)
      tag = helper.link_back_to_catalog
      tag.should =~ /q=query/
      tag.should =~ /f=facets/
      tag.should =~ /per_page=10/
      tag.should =~ /page=2/
    end

    it "should build a link tag to bookmarks using session[:search] for query params" do
      helper.stub(:current_search_session).and_return double(:query_params => @bookmarks_query_params)
      tag = helper.link_back_to_catalog
      tag.should =~ /Back to Bookmarks/
      tag.should =~ /\/bookmarks/
      tag.should =~ /page=2/
    end
  end

  describe "#document_heading" do
    before :each do
      @document = Hash.new
    end

    it "should consist of the show heading field when available" do
     Solrizer.insert_field(@document, "heading", "A Fake Document", :displayable) 
     document_heading.should == "A Fake Document"
    end

    it "should fallback on the document id if no title is available" do
      @document = SolrDocument.new(:id => '123456')
      document_heading.should == '123456'
    end
  end

end
