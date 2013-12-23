require 'spec_helper'

describe Rockhall::Solr::Query do

  before :each do
    @query = Rockhall::Solr::Query.new("foo")
  end

  it "defines all the parameters for a solr query" do
    @query.q.should == "foo"
    @query.fl.should == "id"
  end

end
