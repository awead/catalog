require "spec_helper"

describe CatalogController do

  include Devise::TestHelpers

  describe "#index" do

    before(:each) do
      @user_query = "rock"  # query that will get results
      @no_docs_query = "sadfdsafasdfsadfsadfsadf" # query for no results
      @facet_query = { Solrizer.solr_name("format", :facetable) => "Book" }
    end
    
    # in rails3, the assigns method within ActionDispathc::TestProcess 
    # kindly converts anything that desends from hash to a hash_With_indifferent_access
    # which means that our solr response object gets replaced if we call
    # assigns(:response) - so we can"t do that anymore.
    def assigns_response
      @controller.instance_variable_get("@response")
    end

    # there must be at least one facet, and each facet must have at least one value
    def assert_facets_have_values(facets)
      facets.size.should > 1
      # should have at least one value for each facet, except Archival Material
      facets.each do |facet|
        facet.items.size.should >= 1 unless facet.name.match Solrizer.solr_name("material", :facetable)
      end
    end

    it "should have no search history if no search criteria" do
      controller.should_receive(:get_search_results) 
      session[:history] = []
      get :index
      session[:history].length.should == 0
    end

    # check each user manipulated parameter
    it "should have docs and facets for query with results", :integration => true do
      get :index, :q => @user_query
      assigns_response.docs.size.should > 1
      assert_facets_have_values(assigns_response.facets)
    end
    it "should have docs and facets for existing facet value", :integration => true do
      get :index, :f => @facet_query
      assigns_response.docs.size.should > 1
      assert_facets_have_values(assigns_response.facets)
    end
    it "should have docs and facets for non-default results per page", :integration => true do
      num_per_page = 7
      get :index, :per_page => num_per_page
      assigns_response.docs.size.should == num_per_page
      assert_facets_have_values(assigns_response.facets)
    end

    it "should have docs and facets for second page", :integration => true do
      page = 2
      get :index, :page => page
      assigns_response.docs.size.should > 1
      assigns_response.params[:start].to_i.should == (page-1) * @controller.blacklight_config[:default_solr_params][:rows]
      assert_facets_have_values(assigns_response.facets)
    end

    it "should have no docs or facet values for query without results", :integration => true do
      get :index, :q => @no_docs_query
      assigns_response.docs.size.should == 0
      assigns_response.facets.each do |facet|
        facet.items.size.should == 0
      end
    end

    it "should have a spelling suggestion for an appropriately poor query", :integration => true do
      get :index, :q => "boo"
      assigns_response.spelling.words.should_not be_nil
    end

    describe "session" do
      before do
        controller.stub(:get_search_results) 
      end
      it "should include :search key with hash" do
        get :index
        session[:search].should_not be_nil
        session[:search].should be_kind_of(Hash)
      end
      it "should include search hash with key :q" do
        get :index, :q => @user_query
        session[:search].should_not be_nil
        session[:search].keys.should include(:id)
        
        search = Search.find(session[:search][:id])
        expect(search.query_params[:q]).to eq @user_query
      end
    end

    # check with no user manipulation
    describe "for default query" do
      it "should get documents when no query", :integration => true do
        get :index
        assigns_response.docs.size.should > 1
      end
      it "should get facets when no query", :integration => true do
        get :index
        assert_facets_have_values(assigns_response.facets)
      end
    end

    it "should render index.html.erb" do
      controller.stub(:get_search_results)
      get :index
      response.should render_template(:index)
    end

    # NOTE: status code is always 200 in isolation mode ...
    it "HTTP status code for GET should be 200", :integration => true do
      get :index
      response.should be_success
    end
  end

  describe "#show" do

    it "will display a book", :integration => true do
      get :show, :id => "60373433"
      assigns[:document].get(Solrizer.solr_name("title", :displayable)).should match /African American music/
    end

    describe "#get_component_children" do
      it "includes the child components in a finding aid", :integration => true do
        get :show, :id => "ARC-0037"
        assigns[:components].length.should == 7
      end
    end

    describe "#show_item_within_collection" do
      it "redirects to display an archival item within its collection", :integration => true do
        get :show, :id => "ARC-0037ref2"
        response.should redirect_to("/catalog/ARC-0037/ref2")
      end
    end

    describe "#get_component" do
      it "inclues the component item in the response", :integration => true do
        get :show, :id => "ARC-0037", :ref => "ref2"
        assigns[:component].get(Solrizer.solr_name("title", :displayable)).should == "Series II: Subject Files"
      end
    end

  end

end
