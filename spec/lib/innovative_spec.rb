require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::Innovative do

  describe "#get_holdings" do

    it "should return a partial html table with holdings information" do
      status = Rockhall::Innovative.get_holdings("b3386820")
      status.should be_a_kind_of(Array)
      status.each do |html|
        html.should be_a_kind_of(String)
        html.should match(/<td>/)
      end
    end

  end

  describe "#query_iii" do
    it "should return the html document from III's opac" do
      html = Rockhall::Innovative.query_iii("b3311377")
      html.should be_a_kind_of(Nokogiri::HTML::Document)

    end
  end

  describe "#link" do
    it "should return a url for a given id" do
      link = Rockhall::Innovative.link("foo")
      link.should == "http://" + Blacklight.config[:opac_ip] + "/record=foo"
    end
  end

end