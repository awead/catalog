require 'spec_helper'

describe HoldingsHelper  do
  
  before(:all) do
    class TestClass
      include HoldingsHelper
    end
    @test = TestClass.new
  end

  describe ".status" do
    it "should return a status message for a given code" do
      @test.status["o"].should == "LIB USE ONLY"
      @test.status["p"].should == "In Process"    
    end
  end

end