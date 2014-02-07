require 'spec_helper'

describe MarcHelper do

  # TODO: Need better test coverage
  describe "#render_external_link" do
    it "should handle nils and garbage" do
      expect(helper.render_external_link(nil)).to be_nil
      expect(helper.render_external_link({:document => "foo", :field => "bar"})).to be_nil
    end

  end

  # TODO: Need better test coverage
  describe "#render_facet_link" do
    it "should handle nils and garbage" do
      expect(helper.render_facet_link(nil)).to be_nil
      expect(helper.render_facet_link({:document => "foo", :field => "bar"})).to be_nil
    end
  end

  describe "#document_format_to_filename" do

    before :each do
      @document = SolrDocument.new
    end

    it "returns an image for books" do
      assign :document, Solrizer.insert_field(@document, "format", "Book", :displayable)
      expect(helper.document_format_to_filename).to eq "icons/book.png"
    end

    it "returns an image for archival items" do
      assign :document, Solrizer.insert_field(@document, "format", "Archival Item", :displayable)
      expect(helper.document_format_to_filename).to eq "icons/archival_item.png"
    end

    it "returns an image for an unknown format" do
      expect(helper.document_format_to_filename).to eq "icons/unknown.png"
    end

  end

end
