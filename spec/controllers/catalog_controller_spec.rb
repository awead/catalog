require "spec_helper"

describe CatalogController, :type => :controller do

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
      expect(facets.size).to be > 1
      # should have at least one value for each facet, except Archival Material
      facets.each do |facet|
        expect(facet.items.size).to be >= 1 unless facet.name.match Solrizer.solr_name("material", :facetable)
      end
    end

    it "should have no search history if no search criteria" do
      expect(controller).to receive(:get_search_results) 
      session[:history] = []
      get :index
      expect(session[:history].length).to eq(0)
    end

    # check each user manipulated parameter
    it "should have docs and facets for query with results", :integration => true do
      get :index, :q => @user_query
      expect(assigns_response.docs.size).to be > 1
      assert_facets_have_values(assigns_response.facets)
    end
    it "should have docs and facets for existing facet value", :integration => true do
      get :index, :f => @facet_query
      expect(assigns_response.docs.size).to be > 1
      assert_facets_have_values(assigns_response.facets)
    end
    it "should have docs and facets for non-default results per page", :integration => true do
      num_per_page = 7
      get :index, :per_page => num_per_page
      expect(assigns_response.docs.size).to eq(num_per_page)
      assert_facets_have_values(assigns_response.facets)
    end

    it "should have docs and facets for second page", :integration => true do
      page = 2
      get :index, :page => page
      expect(assigns_response.docs.size).to be > 1
      expect(assigns_response.params[:start].to_i).to eq((page-1) * @controller.blacklight_config[:default_solr_params][:rows])
      assert_facets_have_values(assigns_response.facets)
    end

    it "should have no docs or facet values for query without results", :integration => true do
      get :index, :q => @no_docs_query
      expect(assigns_response.docs.size).to eq(0)
      assigns_response.facets.each do |facet|
        expect(facet.items.size).to eq(0)
      end
    end

    it "should have a spelling suggestion for an appropriately poor query", :integration => true do
      get :index, :q => "boo"
      expect(assigns_response.spelling.words).not_to be_nil
    end

    describe "session" do
      before do
        allow(controller).to receive(:get_search_results) 
      end
      it "should include :search key with hash" do
        get :index
        expect(session[:search]).not_to be_nil
        expect(session[:search]).to be_kind_of(Hash)
      end
      it "should include search hash with key :q" do
        get :index, :q => @user_query
        expect(session[:search]).not_to be_nil
        expect(session[:search].keys).to include(:id)
        
        search = Search.find(session[:search][:id])
        expect(search.query_params[:q]).to eq @user_query
      end
    end

    # check with no user manipulation
    describe "for default query" do
      it "should get documents when no query", :integration => true do
        get :index
        expect(assigns_response.docs.size).to be > 1
      end
      it "should get facets when no query", :integration => true do
        get :index
        assert_facets_have_values(assigns_response.facets)
      end
    end

    it "should render index.html.erb" do
      allow(controller).to receive(:get_search_results)
      get :index
      expect(response).to render_template(:index)
    end

    # NOTE: status code is always 200 in isolation mode ...
    it "HTTP status code for GET should be 200", :integration => true do
      get :index
      expect(response).to be_success
    end
  end

  describe "#show" do

    it "will display a book", :integration => true do
      get :show, :id => "60373433"
      expect(assigns[:document].get(Solrizer.solr_name("title", :displayable))).to match /African American music/
    end

    describe "#get_component_children" do
      it "includes the child components in a finding aid", :integration => true do
        get :show, :id => "ARC-0037"
        expect(assigns[:components].length).to eq(7)
      end
    end

    describe "#show_item_within_collection" do
      it "redirects to display an archival item within its collection", :integration => true do
        get :show, :id => "ARC-0037ref2"
        expect(response).to redirect_to("/catalog/ARC-0037/ref2")
      end
    end

    describe "#get_component" do
      it "inclues the component item in the response", :integration => true do
        get :show, :id => "ARC-0037", :ref => "ref2"
        expect(assigns[:component].get(Solrizer.solr_name("title", :displayable))).to eq("Series II: Subject Files")
      end
    end

  end

end
