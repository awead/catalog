require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::EadSolrMethods do

  include Rockhall::EadSolrMethods

  describe "get_field_from_solr" do
    it "should return the ead_id for a given component id" do
      id = "ARC-0065:2:ref61"
      ead_id = get_field_from_solr("ead_id",id)
      ead_id.should == "ARC-0065"
    end

    it "should return a list of parent references for a given component id" do
      id = "ARC-0065:2:ref61"
      parent_ref_list = get_field_from_solr("parent_ref_list",id)
      parent_ref_list.should be_kind_of(Array)
      parent_ref_list[0].should == "ref42"
    end
  end


  describe "get_component_docs_from_solr" do

    it "should return an array of first-level component documents" do
      pending "Might need to test this in the controller"
    end

  end

end