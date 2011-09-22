require 'net/http'

module Rockhall::Innovative


  def self.get_holdings(id)
    doc = query_iii(id)
    snip = doc.xpath("//tr[@class='bibItemsEntry']")

    results = Array.new
    snip.each do |e|
      string = Sanitize.clean(e.to_s, Sanitize::Config::RESTRICTED)
      if string.match("Rock")
        results << string.strip.gsub(/\n+/,"</td><td>")
      end
    end
    return results
  end

  def self.link(id)
    return "http://" + Blacklight.config[:opac_ip] + "/record=" + id
  end


  def self.query_iii(id)
    url = URI.parse(link(id))
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    doc = Nokogiri::HTML(res.body)
    return doc
  end

end