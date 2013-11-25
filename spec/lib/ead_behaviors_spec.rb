require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::EadBehaviors do

  before(:all) do
    class TestClass
      include Rockhall::EadBehaviors
    end
    @test = TestClass.new
  end

  describe ".compute_range" do

    it "should interpolated accession numbers from one tuple" do
      results = @test.compute_range("A1994.34.19-A1994.34.30")
      results.length.should == 12
      results.include?("A1994.34.19").should be_true
      results.include?("A1994.34.20").should be_true
      results.include?("A1994.34.30").should be_true
    end

    it "should interpolated accession numbers from a range including letters" do
      results = @test.compute_range("A2001.93.2a-A2001.93.2c")
      results.length.should == 3
      results.include?("A2001.93.2a").should be_true
      results.include?("A2001.93.2b").should be_true
      results.include?("A2001.93.2c").should be_true
    end

    it "should not be able to interpolate accession numbers accross multiple tuples" do
      results = @test.compute_range("A1994.29.9-A1994.30.2")
      results.should be_empty
    end
  end

  describe ".ead_accession_range" do

    it "should return an array of a single accession number" do
      results = @test.ead_accession_range("A2005.36.12")
      results.first.should == "A2005.36.12"
    end

    it "should return an array of numbers from a comma-separated list" do
      results = @test.ead_accession_range("A2005.36.8, A2005.36.38, A2005.36.39")
      results.length.should == 3
      results.include?("A2005.36.8").should be_true
      results.include?("A2005.36.38").should be_true
      results.include?("A2005.36.39").should be_true
    end

    it "should return an array of numbers from a range and comma-separated list" do
      results = @test.ead_accession_range("A1994.34.4, A1994.34.7-A1994.34.9")
      results.length.should == 4
      results.include?("A1994.34.4").should be_true
      results.include?("A1994.34.7").should be_true
      results.include?("A1994.34.8").should be_true
      results.include?("A1994.34.9").should be_true
    end

    it "should return an array of accessions from a range including different letters" do
      results = @test.ead_accession_range("A2001.93.2a-A2001.93.2c, L2002.86.30")
      results.length.should == 4
      results.include?("A2001.93.2a").should be_true
      results.include?("A2001.93.2b").should be_true
      results.include?("A2001.93.2c").should be_true
      results.include?("L2002.86.30").should be_true
    end

    it "should return an array of accessions from a formatted string" do
      results = @test.ead_accession_range("Object 8 (signed, original): A2010.1.13")
      results.length.should == 1
      results.include?("A2010.1.13").should be_true

      # Complex example taken from Jeff Gold
      string = "A2001.80.34-A2001.80.35 (John Van Hamersveld original artwork), A2004.54.52-A2004.54.53 (1991 Spring and Summer tour itineraries), A2004.54.199 ("
      results = @test.ead_accession_range(string)
      results.length.should == 5
    end

    it "should accomodate different formats" do
      results = @test.ead_accession_range("A2009.20.2-A2009.20.6; A2009.20.8-A2009.20.10,A2009.20.12 A2009.20.20;A2009.20.22")
      results.length.should == 11
      results.include?("A2009.20.5").should be_true
      results.include?("A2009.20.9").should be_true
      results.include?("A2009.20.12").should be_true
      results.include?("A2009.20.22").should be_true
    end
  end

  describe ".get_language_from_code" do
    it "should return the language term from a given code" do
      @test.get_language_from_code("fre").should == "French"
      @test.get_language_from_code("eng").should == "English"
      @test.get_language_from_code("spa").should == "Spanish"
    end
    it "should return 'None' if it does not match any code" do
      @test.get_language_from_code("xxx").should == "None"
    end
  end

end