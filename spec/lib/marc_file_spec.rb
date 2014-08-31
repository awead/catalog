require "spec_helper"

describe MarcFile do

  before :each do   
    @file = MarcFile.new
  end

  it "should set the start and number of rows" do
    expect(@file.start).to eq(0)
    expect(@file.rows).to  eq(1000000000)
  end

  describe ".get_records" do

    it "should return an array of marc xml documents" do
      result = @file.get_records
      expect(result.first["marc_ss"]).not_to be_nil
      expect(result.first["marc_ss"]).to be_kind_of String
      expect(result.length).to eq(83)
    end

  end

  describe ".write_out" do

    it "should save the marc records to tmp/out.mrc" do
      @file.write_out
      reader = MARC::Reader.new("tmp/out.mrc")
      expect(reader.count).to eq(83)
    end


  end


end