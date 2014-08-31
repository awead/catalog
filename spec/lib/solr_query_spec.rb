require 'spec_helper'

describe Rockhall::Solr::Query do

  before :each do
    @query = Rockhall::Solr::Query.new("foo")
  end

  it "defines all the parameters for a solr query" do
    expect(@query.q).to eq("foo")
    expect(@query.fl).to eq("id")
  end

end
