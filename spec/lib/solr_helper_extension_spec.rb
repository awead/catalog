require "spec_helper"

describe Rockhall::SolrHelperExtension do

  before :each do
    class TestCatalogController < ApplicationController
      include Rockhall::SolrHelperExtension
      include Blacklight::Catalog
    end
    @test = TestCatalogController.new
  end

  describe ".query_ead_components" do
    it "should return an array of first-level component solr documents from params" do
      @test.stub!(:params).and_return({:id => "ARC-0037"}.with_indifferent_access)
      children, parents = @test.query_ead_components
      children.length.should          == 7
      children.first["ref_s"].should  == "ref1"
      parents.should be_empty
    end

    it "should return a an array of first-level components and a hash of parent components" do
      @test.stub!(:params).and_return({:id => "ARC-0037", :ref => "ref1809"}.with_indifferent_access)
      children, parents = @test.query_ead_components
      children.length.should                == 7
      children.first["ref_s"].should        == "ref1"
      parents.keys.should                   == ["ref1", "ref6", "ref208"]
      parents["ref1"].first["ref_s"].should == "ref2277"
      parents["ref1"].last["ref_s"].should  == "ref1033"

    end
  end

  describe ".first_level_ead_components" do
    it "should return an array of first-level solr documents from a given id" do
      children = @test.first_level_ead_components("ARC-0037")
      children.length.should         == 7
      children.first["ref_s"].should == "ref1"
      children.last["ref_s"].should  == "ref1884" 
    end

    it "should return an array starting with a given row" do
      children = @test.first_level_ead_components("ARC-0037", {:start => 2})
      children.length.should         == 5
      children.first["ref_s"].should == "ref176"
      children.last["ref_s"].should  == "ref1884"      
    end

    it "should return an array of a selective range of rows" do
      children = @test.first_level_ead_components("ARC-0037", {:start => 2, :rows => 3})
      children.length.should         == 3
      children.first["ref_s"].should == "ref176"
      children.last["ref_s"].should  == "ref250"
    end
  end

  describe ".get_field_from_solr" do
    it "should return the contents from a solr field" do
      @test.get_field_from_solr("ARC-0037ref1809", "parent_ids_display").should == ["ref1", "ref6", "ref208"]
    end
  end

  describe ".additional_ead_components" do
    it "should return an array of solr documents given an ead and parent document" do
      documents = @test.additional_ead_components("ARC-0037", "ref1")
      documents.length.should         == 222
      documents.first["ref_s"].should == "ref2277"
      documents.last["ref_s"].should  == "ref1033"
    end

    it "should return array starting with a given array" do
      documents = @test.additional_ead_components("ARC-0037", "ref1", {:start => 50})
      documents.length.should         == 172
      documents.first["ref_s"].should == "ref29"
      documents.last["ref_s"].should  == "ref1033"
    end

    it "should return an array of a selective range of rows" do
      documents = @test.additional_ead_components("ARC-0037", "ref1", {:start => 50, :rows => 25})
      documents.length.should         == 25
      documents.first["ref_s"].should == "ref29"
      documents.last["ref_s"].should  == "ref47"
    end
  end


end