require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe HoldingsController do

  describe "show" do

    it "the correct routes" do
      holdings_path.should == "/holdings"
      holding_path("foo").should == "/holdings/foo"
    end

    it "the correct template" do
      post :show, :id=>"foo", :controller=>"holdings"
      response.should render_template "holdings/show"
    end

  end

end