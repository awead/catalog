require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe VideoPlayerHelper, :type => :helper do

  before(:all) do
    class TestClass
      include VideoPlayerHelper
    end
    @test = TestClass.new

  end

  describe "#is_allowable_ip" do

    it "should return false for localhost so we can test for disallowed ips locally" do
      expect(@test.is_allowable_ip?("127.0.0.1")).to be_falsey
    end

    it "should return true for all our subnets" do
      expect(@test.is_allowable_ip?("192.168.250.3")).to be_truthy
      expect(@test.is_allowable_ip?("192.168.251.34")).to be_truthy
      expect(@test.is_allowable_ip?("192.168.252.78")).to be_truthy
    end

    it "should return false for any disallowed ip" do
      expect(@test.is_allowable_ip?("192.168.253.78")).to be_falsey
      expect(@test.is_allowable_ip?("129.79.1.45")).to be_falsey
      expect(@test.is_allowable_ip?("10.0.0.1")).to be_falsey
    end

  end

end
