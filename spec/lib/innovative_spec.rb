require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::Innovative do

  describe "#get_status" do

    it "should return the status for a book" do
      status = Rockhall::Innovative.get_status("b3386820")
      status.should be_a_kind_of(String)
    end

  end

  describe "#link" do
    it "should return a url for a given id" do
      link = Rockhall::Innovative.link("foo")
      link.should == "http://" + Blacklight.config[:opac_ip] + "/record=foo"
    end
  end


end