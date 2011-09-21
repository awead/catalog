require 'net/http'

module Rockhall::Innovative


  def self.get_status(id)
    url = URI.parse(link(id))
    req = Net::HTTP::Get.new(url.path)
    res = Net::HTTP.start(url.host, url.port) {|http|
      http.request(req)
    }
    doc = Nokogiri::HTML(res.body)
    status = doc.xpath("//tr[@class='bibItemsEntry']/td")

    if status.length > 0
      if status.last.text.include? "LIB USE ONLY"
        return "Available in the libary"
      else
        return "Really don't know about this one"
      end
    else
      return nil
    end
  end

  def self.link(id)
    return "http://" + Blacklight.config[:opac_ip] + "/record=" + id
  end

end