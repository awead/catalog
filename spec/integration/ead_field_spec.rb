require 'spec_helper'

describe "EAD Field" do

  describe "date" do
    it "is nil if there is no lanuage code" do
      pending
      response, doc = @test.get_solr_response_for_doc_id("ARC-0037ref2274")
      doc[Solrizer.solr_name("language", :displayable)].should be_nil
    end
    it "has a lanuage code" do
      pending
      response, doc = @test.get_solr_response_for_doc_id("ARC-0006ref508")
      doc[Solrizer.solr_name("language", :displayable)].should == ["English"]
    end
  end

  describe "archival material" do
    it "is displayable" do
      pending
      response, doc = @test.get_solr_response_for_doc_id("ARC-0006ref858")
      doc[Solrizer.solr_name("material", :displayable)].should include("Access Copy")
    end
  end

  describe "location" do
    it "is specially formatted from existing fields" do
      pending
      response, doc = @test.get_solr_response_for_doc_id("ARC-0006ref858")
      doc[Solrizer.solr_name("location", :displayable)].should include("Box: 2, Folder: 9, Object: 2")      
    end
  end

end