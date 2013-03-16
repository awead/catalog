require "spec_helper"

describe MarcFile do

  before :each do   
    @file = MarcFile.new
  end

  it "should set the start and number of rows" do
    @file.start.should == 0
    @file.rows.should  == 1000000000
  end

  describe ".get_records" do

    it "should return an array of marc xml documents" do
      result = @file.get_records
      result.first["marc_display"].should_not be_nil
      result.first["marc_display"].should be_kind_of(String)
      result.length.should == 83
    end

  end

  describe ".write_out" do

    it "should save the marc records to tmp/out.mrc" do
      @file.write_out
      reader = MARC::Reader.new("tmp/out.mrc")
      reader.count.should == 83
    end


  end


end