require 'net/http'

module Rockhall::Innovative

  OPAC_IP = "129.22.104.30"


  def self.get_holdings(id)
    doc = query_iii(id)
    results = Array.new

    unless doc.nil?
      snip = doc.xpath("//tr[@class='bibItemsEntry']")
      snip.each do |e|
        string = Sanitize.clean(e.to_s, Sanitize::Config::RESTRICTED)
        if string.match("Rock")
          results << string.strip.gsub(/\n+/,"</td><td>")
        end
      end
    end
    return results
  end

  def self.link(id)
    return "http://" + OPAC_IP + "/record=" + id
  end


  def self.query_iii(id)
    url = URI.parse(link(id))
    begin
      req = Net::HTTP::Get.new(url.path)
      res = Net::HTTP.start(url.host, url.port,opt={:open_timeout=>10}) {|http|
        http.request(req)
      }
      doc = Nokogiri::HTML(res.body)
    rescue
      doc = nil
    end
    return doc
  end

end
