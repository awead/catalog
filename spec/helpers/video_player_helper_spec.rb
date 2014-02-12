require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VideoPlayerHelper do

  before(:all) do
    class TestClass
      include VideoPlayerHelper
    end
    @test = TestClass.new

  end

  describe "#is_allowable_ip" do

    it "should return false for localhost so we can test for disallowed ips locally" do
      @test.is_allowable_ip?("127.0.0.1").should be_false
    end

    it "should return true for all our subnets" do
      @test.is_allowable_ip?("192.168.250.3").should be_true
      @test.is_allowable_ip?("192.168.251.34").should be_true
      @test.is_allowable_ip?("192.168.252.78").should be_true
    end

    it "should return false for any disallowed ip" do
      @test.is_allowable_ip?("192.168.253.78").should be_false
      @test.is_allowable_ip?("129.79.1.45").should be_false
      @test.is_allowable_ip?("10.0.0.1").should be_false
    end

  end

end
