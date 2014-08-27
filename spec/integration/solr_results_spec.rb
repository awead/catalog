require 'spec_helper'

describe "Solr results", :type => :request do

  it "should have correctly-ordered ead documents" do
    query = Rockhall::Solr::Query.new('format_sim:"Archival Collection"')
    solr_response = Blacklight.solr.get "select", :params => query.instance_values
    docs = solr_response["response"]["docs"]
    expect(docs[0]["id"]).to eq("ARC-0064")
    expect(docs[1]["id"]).to eq("ARC-0001")
    expect(docs[2]["id"]).to eq("ARC-0161")
    expect(docs[3]["id"]).to eq("ARC-0005")
    expect(docs[4]["id"]).to eq("ARC-0258")
    expect(docs[5]["id"]).to eq("ARC-0118")
  end

  it "should have correctly-ordered ead components" do
    query = Rockhall::Solr::Query.new('format_sim:"Archival Item"')
    query.sort = (Solrizer.solr_name("title", :sortable) + " ASC")
    solr_response = Blacklight.solr.get "select", :params => query.instance_values
    docs = solr_response["response"]["docs"]
    expect(docs[0]["id"]).to eq("RG-0008ref7")
    expect(docs[1]["id"]).to eq("ARC-0006ref343")
    expect(docs[2]["id"]).to eq("ARC-0258ref9")
    expect(docs[3]["id"]).to eq("ARC-0001ref2546")
    expect(docs[4]["id"]).to eq("RG-0008ref4")
    expect(docs[5]["id"]).to eq("ARC-0006ref344")
  end

end
