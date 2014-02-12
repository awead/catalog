require 'spec_helper'

describe SubjectsHelper do
  
  before(:all) do
    class TestClass
      include SubjectsHelper
    end
    @test = TestClass.new
  end

  describe "#format_subjects" do
    it "should return an 2d array of formatted fields" do
      results = format_subjects marc_fixture("601137822.mrc").to_xml.to_s
      results.should include(["Rock musicians", "United States"])
      results.should include(["Lennon, John, 1940-1980", "Assassination"])
      results.should include(["Inductee"])
    end
  end

  describe "formatting subject fields" do

    it "should reuturn an array with names and subfields" do
      field = MARC::DataField.new('600','0','0',
        MARC::Subfield.new('a', 'Lennon, John, '),
        MARC::Subfield.new('d', '1940-1980 '),
        MARC::Subfield.new('x', 'Assassination. '))
      subject_field_with_name(field).should == [ "Lennon, John, 1940-1980", "Assassination"] 
    end

    it "should return an array of subfields" do
      field = MARC::DataField.new('650','0','0',
        MARC::Subfield.new('a', 'Rock musicians '),
        MARC::Subfield.new('z', 'England '),
        MARC::Subfield.new('v', 'Biography'))
      subject_field_without_name(field).should == [ "Rock musicians", "England", "Biography" ]
    end

  end

  describe "#format_subject_links" do

    it "should return a hash of terms and their query terms" do
      results = format_subject_links [ "Rock Musicians", "England", "Biography" ]
      results.should be_kind_of(Hash)
      results["Rock Musicians"].should == [ "Rock Musicians" ]
      results["England"].should        == [ "Rock Musicians", "England" ]
      results["Biography"].should      == [ "Rock Musicians", "England", "Biography" ]
    end

  end

  describe "#format_ead_subjects" do

    it "should return a 2D array of subject terms from a solr array" do
      a = ["Disc jockeys", "Music trade--United States", "Radio personalities", "Rock concerts", "Rock music--To 1961", "Rock music--United States"]
      r = format_ead_subjects(a)
      r.first.should == ["Disc jockeys"]
      r.last.should  == ["Rock music", "United States"]
    end

  end

end
