require "spec_helper"

describe ComponentsHelper do

  before :each do
    class TestComponentsHelper
      include ComponentsHelper
    end
    @test = TestComponentsHelper.new
  end

  describe ".should_display_component_field?" do
    it "should return true for fields we want displayed" do
      @test.should_display_component_field?("scopeconent_display").should be_true
    end

    it "should return false for fields we don't want displayed" do
      @test.should_display_component_field?("title_display").should be_false
    end
  end


end