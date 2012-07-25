module HoldingsHelper

  include Rockhall::Innovative

  def opac_link(iii_id)
    results = String.new
    link = Rockhall::Innovative.link(iii_id.first.to_s)
    results << "<h5>" + link_to("View in opac", link) + "</h5>"
    return nil
  end

  def show_status(doc)
    results = String.new
    unless doc[:format].match("Website") or doc[:format].match("Periodical")
      if doc[:innovative_display]
        results << "<div class=\"innovative_status\" id=\"#{doc[:innovative_display].first}\"><b>Status: </b></div>"
      end
    end
    return results.html_safe
  end

  def check_availability(iii_id)
    results = String.new
    return nil if @document[:format].match("Website")
    status = Rockhall::Innovative.get_holdings(iii_id.first.to_s)
    if status.first
      results << "<h3>Holdings</h3>"
      results << "<table>"
      results << "<tr><th>Location</th><th>Call Number</th><th>Availability</th>"
      if @document[:format].match("Periodical")
        results << "<th>Issues</th></tr>"
      else
        results << "</tr>"
      end
      status.each do |s|
        results << "<tr><td>" + s.to_s + "</td>"
        if @document[:format].match("Periodical")
          link = "http://catalog.case.edu/record=" + @document[:innovative_t].to_s
          results << "<td>" + link_to("Click for Holdings", link, { :target => "_blank"})  + "</td></tr>"
        else
          results << "</tr>"
        end
      end
      results << "</table>"
    else
      results << "<h3>Holdings</h3>"
      results << "Unavailable"
    end
    return results.html_safe
  end


end