require 'spec_helper'

describe HoldingsHelper  do

  def marc_document doc = SolrDocument.new
    Solrizer.insert_field(doc, "innovative", "foo", :displayable)
    return doc
  end

  describe "#show_full_holdings" do
    it "renders a div that is later populated with html from an ajax call" do
      assign :document, marc_document
      expect(helper.show_full_holdings).to eq '<div class="innovative_holdings" id="foo"></div>'
    end
    it "renders a link for periodical holdings" do
      assign :document, Solrizer.insert_field(marc_document, "format", "Periodical", :displayable)
      expect(helper.show_holdings).to eq '<a href="http://129.22.104.30/record=foo" target="_blank">Click for Holdings</a>'
    end
    it "returns nil for websites" do
      assign :document, Solrizer.insert_field(marc_document, "format", "Website", :displayable)
      expect(helper.show_holdings).to eq nil
    end
  end

  describe "#show_holdings" do
    it "renders a div that is later populated with html from an ajax call" do
      assign :document, marc_document
      expect(helper.show_holdings).to eq '<span class="innovative_status label label-default" id="foo_status">checking status...</span>'
    end
    it "returns nil for websites" do
      assign :document, Solrizer.insert_field(marc_document, "format", "Website", :displayable)
      expect(helper.show_holdings).to eq nil
    end
    it "returns periodical holdings" do
      assign :document, Solrizer.insert_field(marc_document, "format", "Periodical", :displayable)
      expect(helper.show_holdings).to eq '<a href="http://129.22.104.30/record=foo" target="_blank">Click for Holdings</a>'
    end
  end

end
