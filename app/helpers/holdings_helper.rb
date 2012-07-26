module HoldingsHelper

  include Rockhall::Innovative

  def opac_link(iii_id)
    results = String.new
    link = Rockhall::Innovative.link(iii_id.first.to_s)
    results << "<h5>" + link_to("View in opac", link) + "</h5>"
    return nil
  end

  def show_holdings(doc,opts={})
    results = String.new
    unless doc[:format].match("Website")
      if doc[:innovative_display]
        if opts[:full]
          results << "<div class=\"innovative_holdings\" id=\"#{doc[:innovative_display].first}\"></div>"
          if doc[:format].match("Periodical")
            results << link_to("Click for Holdings", Rockhall::Innovative.link(doc[:innovative_display].first), { :target => "_blank"})
          end
        else
          if doc[:format].match("Periodical")
            results << "<div><b>"
            results << link_to("Click for Holdings", Rockhall::Innovative.link(doc[:innovative_display].first), { :target => "_blank"})
            results << "</b></div>"
          else
            results << "<div class=\"innovative_status\" id=\"#{doc[:innovative_display].first}\"><b>checking status... </b></div>"
          end
        end
      end
    end
    return results.html_safe
  end


  def old_check_availability
    results = String.new
    return nil if @document[:format].match("Website")
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