require 'spec_helper'

describe EadHelper do

  include Devise::TestHelpers

  def blacklight_config
    @config ||= Blacklight::Configuration.new.configure do |config|
      config.show.title_field = Solrizer.solr_name("heading", :displayable)
    end
  end

  def ead_document document = Hash.new
    Solrizer.insert_field(document, "ead", "ARC-0003", :stored_sortable)
    return document
  end

  def digital_ead_component component = Hash.new
    Solrizer.insert_field(component, "access_file", "file.mp4", :displayable)
    return component
  end

  def physical_ead_component 
    component = Hash.new
  end

  before :each do
    helper.stub(:blacklight_config => blacklight_config)
  end 

  describe "document helper methods" do

    before :each do
      assign :document, ead_document
    end

    describe "#render_ead_html" do
      it "renders an html file" do
        expect(helper.render_ead_html).to match "Milt Gabler Papers"
      end
    end

  end

  describe "component helper methods" do

    describe "#render_archival_item_detail" do
      it "renders the digital component partial" do
        assign :component, digital_ead_component
        expect(helper.render_archival_item_detail).to match "video-splash.png"
      end

      it "renders the physical component partial" do
        assign :component, physical_ead_component
        expect(helper.render_archival_item_detail).to_not match "video-splash.png"
      end
    end

  end

end
