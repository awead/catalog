require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe LocalBlacklightHelper do

  describe "application_helper" do
    it "should return the name of our application" do
      application_name.should == "Mockalog"
    end
  end


end