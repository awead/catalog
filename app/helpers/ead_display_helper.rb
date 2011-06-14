module EadDisplayHelper

  def general_info
    results = String.new
    results << "<table>"
    Blacklight.config[:ead_fields][:field_names].each do | field |
      label = Blacklight.config[:ead_fields][:labels][field.to_s]
      unless @document[field.to_s].nil? or label.nil?
        results << "<tr><td><b>#{label}:</b></td>"
        results << "<td>"
        @document[field.to_s].each do |v|
          results << "#{v}<br/>"
        end
        results << "</td></tr>"
      end
    end
    results << "</table>"
    return results.html_safe
  end


  def ead_headings
    results = String.new
    Blacklight.config[:ead_fields][:field_names].each do | field |
      label = Blacklight.config[:ead_fields][:headings][field.to_s]
      unless @document[field.to_s].nil? or label.nil?
        results << "<h2>#{label}</h2>"
        @document[field.to_s].each do | v|
          results << "<p>#{v}</p>"
        end
      end
    end
    return results.html_safe
  end




end