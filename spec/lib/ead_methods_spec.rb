require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::EadMethods do

  describe "ead_accession_range" do

    it "should return an array of a single accession number" do
      results = Rockhall::EadMethods.ead_accession_range("A2005.36.12")
      results.length.should == 1
      results.first.should == "A2005.36.12"
    end

    it "should return an array of numbers from a comma-separated list" do
      results = Rockhall::EadMethods.ead_accession_range("A2005.36.8, A2005.36.38, A2005.36.39")
      results.length.should == 3
      results.include?("A2005.36.8").should be_true
      results.include?("A2005.36.38").should be_true
      results.include?("A2005.36.39").should be_true
    end

    it "should return a list of numbers from a range" do
      results = Rockhall::EadMethods.ead_accession_range("A1994.34.19-A1994.34.30")
      results.length.should == 12
      results.include?("A1994.34.19").should be_true
      results.include?("A1994.34.20").should be_true
      results.include?("A1994.34.30").should be_true
    end

    it "should return an array of numbers from a range and comma-separated list" do
      results = Rockhall::EadMethods.ead_accession_range("A1994.34.4, A1994.34.7-A1994.34.9")
      results.length.should == 4
      results.include?("A1994.34.4").should be_true
      results.include?("A1994.34.7").should be_true
      results.include?("A1994.34.8").should be_true
      results.include?("A1994.34.9").should be_true
    end

  end

  describe "ead_accessions" do

    it "should return an array of accessions from a component node" do
      raw = File.read("#{RAILS_ROOT}/test/data/ead/ARC-0118.xml")
      raw.gsub!(/xmlns=".*"/, '')
      xml = Nokogiri::XML(raw)
      results = Rockhall::EadMethods.ead_accessions(xml)
      results.length.should == 63
      ["A2005.36.40", "A2005.36.55", "A2005.36.8", "A2005.36.38", "A2005.36.39", "A2005.36.45"].each do |a|
        results.include?(a.to_s).should be_true
      end
    end

    it "should return nil for ead that have no accessions" do
      raw = File.read("#{RAILS_ROOT}/test/data/ead/ARC-0065.xml")
      raw.gsub!(/xmlns=".*"/, '')
      xml = Nokogiri::XML(raw)
      results = Rockhall::EadMethods.ead_accessions(xml)
      results.should be_nil
    end

  end


end