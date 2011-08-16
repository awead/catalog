require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::EadMethods do

  include Rockhall::EadMethods

  before(:all) do
    file = "#{RAILS_ROOT}/test/data/ead/ARC-0005.xml"
    @xml = Rockhall::EadMethods.ead_rake_xml(file)
  end


  describe "ead_rake_xml" do
    it "should return an xml document from an ead" do
      @xml.should be_kind_of(Nokogiri::XML::Document)
    end
  end

  describe "ead_id" do
    it "should return the ead id from an ead xml file" do
      id = Rockhall::EadMethods.ead_id(@xml)
      id.should == "ARC-0005"
    end
  end

  describe "ead_collection" do
    it "should return the name of a collection from the ead document" do
      name = Rockhall::EadMethods.ead_collection(@xml)
      name.should == "Eddie Cochran Historical Organization Collection"
    end
  end

  describe "ead_xml" do
    it "should return the ead xml portion from a solr document" do
      solr_response = Blacklight.solr.find({ :q => "id:ARC-0005", :qt => "standard" })
      xml = Rockhall::EadMethods.ead_xml(solr_response[:response][:docs].first)
    end
  end

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

  describe "ead_solr_field" do
    it "should return all the configured fields from and ead document" do

      solr_doc = Hash.new
      Blacklight.config[:ead_fields].keys.each do | field |
        xpath = Blacklight.config[:ead_fields][field.to_sym][:xpath]
        result = ead_solr_field(@xml,xpath,field)
        unless result.nil?
          solr_doc.merge!(result)
        end
      end

      solr_doc[:ead_title_display].first.should == "Eddie Cochran Historical Organization Collection"

    end
  end

  describe "ead_prep_component" do

    before(:each) do
      @node = @xml.search("//c03")
      @part, children = ead_prep_component(@node,"3")
    end

    describe "ead_location" do
      it "should return the formatted location of ead component" do
        location = ead_location(@part)
        location.should == "Box: 2, Folder: 1"
      end
    end

    describe "ead_material" do
      it "should return the material type from the label attribute" do
        material = ead_material(@part)
        material.should == "Graphic materials"
      end
    end

    describe "ead_parent_refs" do
      it "should return an array of parent components" do
        refs = ead_parent_refs(@node.first,3)
        refs.should be_kind_of(Array)
        refs.should =~ ["ref11", "ref14"]
      end
    end

    describe "ead_parent_unittitles" do
      it "should return an array of parent titles for a component" do
        titles = ead_parent_unittitles(@node.first,3)
        titles.should be_kind_of(Array)
        titles.should =~ ["Series II: Graphic Materials", "Subseries 1: Photographic Materials"]
      end
    end

  end

  describe "ead_clean_xml" do
    it "should strip out unwanted characters from ead fields and correct for ead->html formatting" do
      sample = '
        <title render="italic">Spin</title> magazine and working on three book projects:
        <title render="italic">Tupac Shakur</title>,
        <title render="italic">The Vibe History of Hip Hop</title>, and
        <title render="italic">The Skills to Pay the Bills: The Story of the Beastie Boys</title>.
      '
      clean = ead_clean_xml(sample)
      clean.should == "<i>Spin</i> magazine and working on three book projects: <i>Tupac Shakur</i>, <i>The Vibe History of Hip Hop</i>, and <i>The Skills to Pay the Bills: The Story of the Beastie Boys</i>."
    end
  end

end