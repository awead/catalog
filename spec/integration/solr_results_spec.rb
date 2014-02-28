require 'spec_helper'

describe "Solr results" do

  it "should have correctly-ordered ead documents" do
    query = Rockhall::Solr::Query.new('format_sim:"Archival Collection"')
    solr_response = Blacklight.solr.get "select", :params => query.instance_values
    docs = solr_response["response"]["docs"]
    docs[0]["id"].should == "ARC-0064"
    docs[1]["id"].should == "ARC-0161"
    docs[2]["id"].should == "ARC-0005"
    docs[3]["id"].should == "ARC-0258"
    docs[4]["id"].should == "ARC-0118"
  end

  it "should have correctly-ordered ead components" do
    query = Rockhall::Solr::Query.new('format_sim:"Archival Item"')
    query.sort = (Solrizer.solr_name("title", :sortable) + " ASC")
    solr_response = Blacklight.solr.get "select", :params => query.instance_values
    docs = solr_response["response"]["docs"]
    docs[0]["id"].should == "RG-0008ref7"
    docs[1]["id"].should == "ARC-0006ref343"
    docs[2]["id"].should == "ARC-0258ref9"
    docs[3]["id"].should == "RG-0008ref4"
    docs[4]["id"].should == "ARC-0006ref344"
  end

end
