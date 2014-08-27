require File.expand_path(File.dirname(__FILE__) + '/../spec_helper')

describe Rockhall::Innovative do

  describe "#get_holdings" do

    describe "with WebMock" do

      before :all do
        WebMock.enable!
        stub_request(:get, "http://129.22.104.30/record=b3386820").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
         to_return(:body => webmock_fixture("b3386820.txt"), :status => 200)
      end
      
      after :all do
        WebMock.disable!
      end

      it "should return a partial html table with holdings information" do
        Rails.configuration.rockhall_config[:opac_ip] = "129.22.104.30"
        status = Rockhall::Innovative.get_holdings("b3386820")
        expect(status).to be_a_kind_of(Array)
        status.each do |html|
          expect(html).to be_a_kind_of(String)
          expect(html).to match(/<td>/)
        end
      end

    end

    it "should return 'unknown' for non-existent items" do
      Rails.configuration.rockhall_config[:opac_ip] = "0.0.0.0"
      status = Rockhall::Innovative.get_holdings("b3386820")
      expect(status.first).to eq('unknown')
    end

    it "should return 'unknown if the host is down" do
      Rails.configuration.rockhall_config[:opac_ip] = "1.2.3.4"
      status = Rockhall::Innovative.get_holdings("b3386820")
      expect(status.first).to eq('unknown')
    end

  end

  describe "#query_iii" do

    describe "with WebMock" do

      before :all do
        WebMock.enable!
        stub_request(:get, "http://129.22.104.30/record=b3311377").
         with(:headers => {'Accept'=>'*/*', 'User-Agent'=>'Ruby'}).
         to_return(:body => webmock_fixture("b3311377.txt"), :status => 200)
      end
      
      after :all do
        WebMock.disable!
      end

      it "should return the html document from III's opac" do
        Rails.configuration.rockhall_config[:opac_ip] = "129.22.104.30"
        html = Rockhall::Innovative.query_iii("b3311377")
        expect(html).to be_a_kind_of(Nokogiri::HTML::Document)
      end

    end

    it "should return return null if the host is down" do
      Rails.configuration.rockhall_config[:opac_ip] = "1.2.3.4"
      html = Rockhall::Innovative.query_iii("b3311377")
      expect(html).to be_nil

    end

  end

  describe "#link" do
    it "should return a url for a given id" do
      Rails.configuration.rockhall_config[:opac_ip] = "0.0.0.0"
      link = Rockhall::Innovative.link("foo")
      expect(link).to eq("http://0.0.0.0/record=foo")
    end
  end

end