require 'spec_helper'

describe MarcHelper do
  
  before(:all) do
    class TestClass
      include MarcHelper
    end
    @test = TestClass.new
  end

  describe ":render_external_link" do
    it "should handle nils and garbage" do
      @test.render_external_link(nil).should be_nil
      @test.render_external_link({:document => "foo", :field => "bar"}).should be_nil
    end
  end

  describe ":render_facet_link" do
    it "should handle nils and garbage" do
      @test.render_facet_link(nil).should be_nil
      @test.render_facet_link({:document => "foo", :field => "bar"}).should be_nil
    end
  end

end