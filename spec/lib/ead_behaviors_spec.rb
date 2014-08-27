require 'spec_helper'

describe Rockhall::Ead::Behaviors do

  before(:all) do
    class TestClass
      include Rockhall::Ead::Behaviors
    end
    @test = TestClass.new
  end

  describe ".compute_range" do

    it "should interpolated accession numbers from one tuple" do
      results = @test.compute_range("A1994.34.19-A1994.34.30")
      expect(results.length).to eq(12)
      expect(results.include?("A1994.34.19")).to be_truthy
      expect(results.include?("A1994.34.20")).to be_truthy
      expect(results.include?("A1994.34.30")).to be_truthy
    end

    it "should interpolated accession numbers from a range including letters" do
      results = @test.compute_range("A2001.93.2a-A2001.93.2c")
      expect(results.length).to eq(3)
      expect(results.include?("A2001.93.2a")).to be_truthy
      expect(results.include?("A2001.93.2b")).to be_truthy
      expect(results.include?("A2001.93.2c")).to be_truthy
    end

    it "should not be able to interpolate accession numbers accross multiple tuples" do
      results = @test.compute_range("A1994.29.9-A1994.30.2")
      expect(results).to be_empty
    end
  end

  describe ".ead_accession_range" do

    it "should return an array of a single accession number" do
      results = @test.ead_accession_range("A2005.36.12")
      expect(results.first).to eq("A2005.36.12")
    end

    it "should return an array of numbers from a comma-separated list" do
      results = @test.ead_accession_range("A2005.36.8, A2005.36.38, A2005.36.39")
      expect(results.length).to eq(3)
      expect(results.include?("A2005.36.8")).to be_truthy
      expect(results.include?("A2005.36.38")).to be_truthy
      expect(results.include?("A2005.36.39")).to be_truthy
    end

    it "should return an array of numbers from a range and comma-separated list" do
      results = @test.ead_accession_range("A1994.34.4, A1994.34.7-A1994.34.9")
      expect(results.length).to eq(4)
      expect(results.include?("A1994.34.4")).to be_truthy
      expect(results.include?("A1994.34.7")).to be_truthy
      expect(results.include?("A1994.34.8")).to be_truthy
      expect(results.include?("A1994.34.9")).to be_truthy
    end

    it "should return an array of accessions from a range including different letters" do
      results = @test.ead_accession_range("A2001.93.2a-A2001.93.2c, L2002.86.30")
      expect(results.length).to eq(4)
      expect(results.include?("A2001.93.2a")).to be_truthy
      expect(results.include?("A2001.93.2b")).to be_truthy
      expect(results.include?("A2001.93.2c")).to be_truthy
      expect(results.include?("L2002.86.30")).to be_truthy
    end

    it "should return an array of accessions from a formatted string" do
      results = @test.ead_accession_range("Object 8 (signed, original): A2010.1.13")
      expect(results.length).to eq(1)
      expect(results.include?("A2010.1.13")).to be_truthy

      # Complex example taken from Jeff Gold
      string = "A2001.80.34-A2001.80.35 (John Van Hamersveld original artwork), A2004.54.52-A2004.54.53 (1991 Spring and Summer tour itineraries), A2004.54.199 ("
      results = @test.ead_accession_range(string)
      expect(results.length).to eq(5)
    end

    it "should accomodate different formats" do
      results = @test.ead_accession_range("A2009.20.2-A2009.20.6; A2009.20.8-A2009.20.10,A2009.20.12 A2009.20.20;A2009.20.22")
      expect(results.length).to eq(11)
      expect(results.include?("A2009.20.5")).to be_truthy
      expect(results.include?("A2009.20.9")).to be_truthy
      expect(results.include?("A2009.20.12")).to be_truthy
      expect(results.include?("A2009.20.22")).to be_truthy
    end
  end

  describe ".get_language_from_code" do
    it "should return the language term from a given code" do
      expect(@test.get_language_from_code("fre")).to eq("French")
      expect(@test.get_language_from_code("eng")).to eq("English")
      expect(@test.get_language_from_code("spa")).to eq("Spanish")
    end
    it "should return 'None' if it does not match any code" do
      expect(@test.get_language_from_code("xxx")).to be_nil
    end
  end

end