require 'spec_helper'

describe MarcHelper do

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
