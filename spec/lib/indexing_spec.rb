require "spec_helper"

describe Rockhall::Indexing do

  describe "::get_eadid_from_file" do
    it "should return an ead id from an xml file" do
      Rockhall::Indexing.get_eadid_from_file(ead_fixture "ARC.0005-ead.xml").should == "ARC-0005"
      Rockhall::Indexing.get_eadid_from_file(ead_fixture "ARC.0003-ead.xml").should == "ARC-0003"
    end

    it "should raise in error when the id is nil" do
      file = File.new("/tmp")
      lambda { Rockhall::Indexing.get_eadid_from_file(file)}.should raise_error
    end
  end

  describe "::valid_ead?" do
    it "should return true for a valid eadid" do
      Rockhall::Indexing.valid_ead?("ARC-0005").should be_true
      Rockhall::Indexing.valid_ead?("RG-0001").should  be_true
    end

    it "should return false for an invalid eadid" do
      Rockhall::Indexing.valid_ead?("ARC.0005").should be_false
      Rockhall::Indexing.valid_ead?("RG.0001").should  be_false
      Rockhall::Indexing.valid_ead?("rg-0001").should  be_false
      Rockhall::Indexing.valid_ead?("ARC0005").should  be_false
    end
  end

end