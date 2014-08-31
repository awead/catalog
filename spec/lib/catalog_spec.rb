require 'spec_helper'

describe Rockhall::Catalog do
  
  before :each do
    class TestCatalogController < ApplicationController
      include Rockhall::Catalog
    end
    @test = TestCatalogController.new
  end

  describe ".get_component_children" do
    it "should return an array of first-level component solr documents using the params hash" do
      allow(@test).to receive(:params).and_return({:id => "ARC-0037"}.with_indifferent_access)
      numfound, components = @test.get_component_children
      expect(components.length).to eq(numfound)
      expect(components.first[Solrizer.solr_name("ref", :stored_sortable)]).to  eq("ref1")
    end

  end

  describe ".get_component" do
    it "should return a component from hydra" do
      allow(@test).to receive(:params).and_return({:id => "RG-0010", :ref => "rrhof:2207"}.with_indifferent_access)
      component = @test.get_component
    end
  end

end