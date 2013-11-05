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
      result.first[Solrizer.solr_name("marc", :displayable)].should_not be_nil
      result.first[Solrizer.solr_name("marc", :displayable)].should be_kind_of Array
      result.first[Solrizer.solr_name("marc", :displayable)].count.should == 1
      result.first[Solrizer.solr_name("marc", :displayable)].first.should be_kind_of String
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