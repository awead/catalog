require "spec_helper"

describe Rockhall::SolrHelperExtension do

  before :each do
    class TestCatalogController < ApplicationController
      include Rockhall::SolrHelperExtension
      include Blacklight::Catalog
    end
    @test = TestCatalogController.new
  end

  describe ".get_children_for_component" do
    it "should return an array of first-level component solr documents using the params hash" do
      @test.stub(:params).and_return({:id => "ARC-0037"}.with_indifferent_access)
      numfound, components = @test.get_children_for_component
      components.length.should == numfound
      components.first[Solrizer.solr_name("ref", :stored_sortable)].should  == "ref1"
    end

  end

  describe ".get_ead_component" do
    it "should return a component from hydra" do
      @test.stub(:params).and_return({:id => "RG-0010", :ref => "rrhof:2207"}.with_indifferent_access)
      component = @test.get_ead_component
    end
  end

  describe ".first_level_ead_components" do

    it "should return an array documents from ARC-0037" do
      numfound, children = @test.first_level_ead_components("ARC-0037")
      children.length.should         == 7
      children.first[Solrizer.solr_name("ref", :stored_sortable)].should == "ref1"
      children.last[Solrizer.solr_name("ref", :stored_sortable)].should  == "ref1884" 
    end

    it "should return the maximum array of components" do
      numfound, children = @test.first_level_ead_components("RG-0008")
      children.length.should == Rails.configuration.rockhall_config[:max_components]
    end

    it "should return an array starting with a given row" do
      numfound, children = @test.first_level_ead_components("ARC-0037", {:start => 2})
      children.length.should         == 5
      children.first[Solrizer.solr_name("ref", :stored_sortable)].should == "ref176"
      children.last[Solrizer.solr_name("ref", :stored_sortable)].should  == "ref1884"      
    end

    it "should return an array of a selective range of rows" do
      numfound, children = @test.first_level_ead_components("ARC-0037", {:start => 2, :rows => 3})
      children.length.should         == 3
      children.first[Solrizer.solr_name("ref", :stored_sortable)].should == "ref176"
      children.last[Solrizer.solr_name("ref", :stored_sortable)].should  == "ref250"
    end
  end

  describe ".get_field_from_solr" do
    it "should return the contents from a solr field" do
      @test.get_field_from_solr("ARC-0037ref1809", Solrizer.solr_name("parent", :displayable)).should == ["ref1", "ref6", "ref208"]
    end
  end

  describe ".ead_components_from_parent" do
    it "should return an array of solr documents given an ead and parent document" do
      numfound, documents = @test.ead_components_from_parent("ARC-0037", "ref1")
      documents.first[Solrizer.solr_name("ref", :stored_sortable)].should == "ref2277"
    end

    it "should return array starting with a given array" do
      numfound, documents = @test.ead_components_from_parent("ARC-0037", "ref1", {:start => 50})
      documents.first[Solrizer.solr_name("ref", :stored_sortable)].should == "ref29"
    end

    it "should return an array of a selective range of rows" do
      numfound, documents = @test.ead_components_from_parent("ARC-0037", "ref1", {:start => 50, :rows => 25})
      documents.length.should == 25
      documents.first[Solrizer.solr_name("ref", :stored_sortable)].should == "ref29"
      documents.last[Solrizer.solr_name("ref", :stored_sortable)].should  == "ref47"
    end

    it "should return components imported from hydra" do
      numfound, documents = @test.ead_components_from_parent("RG-0010", "ref42")
      documents.collect { |doc| doc[Solrizer.solr_name("ref", :stored_sortable)] }.should include "rrhof:2207"
    end
  end

  describe ".add_additional_fields_to_hydra_component" do
    it "should merge fields into the component solr document" do
      @test.stub(:params).and_return({:id => "RG-0010", :ref => "rrhof:2207"}.with_indifferent_access)
      @test.get_ead_component
      @test.add_additional_fields_to_hydra_component
      @test.instance_values["component"][(Solrizer.solr_name("parent_unittitles", :displayable))].should == ["Subgroup 1: Annual Induction Ceremonies", "Series II: Digital Video"]
      @test.instance_values["component"][(Solrizer.solr_name("parent", :displayable))].should == ["ref1", "ref42"]
    end
  end

end