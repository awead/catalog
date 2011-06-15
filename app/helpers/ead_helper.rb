module EadHelper


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
        results << "<h2 id=\"#{field}\">#{label}</h2>"
        @document[field.to_s].each do | v|
          results << "<p>#{v}</p>"
        end
      end
    end
    return results.html_safe
  end


  def ead_access_headings
    results = String.new
    results << "<ul>"
    values = @document["subject_topic_facet"].sort
    values.each do |v|
      results << "<li>#{v}</li>"
    end
    results << "</ul>"
    return results.html_safe
  end


  # These methods originated from the blacklight_ext_ead_simple plugin

  def ead_link_id(element, xpath)
    element.attribute('id') || xpath.split('/').last
  end

  def ead_text(element, xpath)
    first = element.xpath(xpath).first
    if first
      first.text
    end
  end

  def ead_paragraphs(element)
    results = String.new
    if element
      element.xpath('p').map do |p|
        if !p.xpath('list').blank?
          p.xpath('list').map do |list|
            results << '<p>' + ead_list(list) + '</p>'
          end
        else
          results << "<p>#{p.text}</p>"
        end
      end
    end
    return results.html_safe
  end

  def ead_list(list)
    ol = ['<ol>']
    list.xpath('item').map do |item|
      ol << '<li>' + item.text + '</li>'
    end
    ol << '</ol>'
    ol.join('')
  end

  def ead_contents
    results = String.new
    Blacklight.config[:ead_fields][:field_names].each do |f|
      unless Blacklight.config[:ead_fields][:headings][f.to_s].nil?
        results << "<li>"
        results << link_to(Blacklight.config[:ead_fields][:headings][f.to_s], catalog_path(@document["ead_id"], :anchor => f))
        results << "</li>"
      end
    end
    return results.html_safe
  end

end