require 'spec_helper'

describe HoldingsController, :type => :controller do

  describe "show" do

    it "should render a brief template by default" do
      get :show, :id=>"foo", :controller=>"holdings"
      expect(response).to render_template "holdings/show/_brief"
    end

    it "should render a full template" do
      get :show, {:id=>"foo", :type=>"full"}, :controller=>"holdings"
      expect(response).to render_template "holdings/show/_full"
    end

  end

end
