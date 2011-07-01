module ArchivalCollectionHelper


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
      unless label.nil?
        # Override display from Solr field with partial
        if self.respond_to?(field.to_sym)
          results << self.send(field.to_sym)
        else
          unless @document[field.to_s].nil?
            results << "<h2 id=\"#{field}\">#{label}</h2>"
            @document[field.to_s].each do | v|
              results << "<p>#{v}</p>"
            end
          end
        end
      end
    end
    return results.html_safe
  end


  def ead_access_headings
    results = String.new
    unless @document["subject_topic_facet"].nil?
      results << "<h2 id=\"access_headings\">Controlled Access Headings</h2>"
      results << "<ul>"
      @document["subject_topic_facet"].sort.each do |v|
        results << "<li>#{v}</li>"
      end
      results << "</ul>"
    end
    return results.html_safe
  end


  def ead_bio_display
    results = String.new
    results << "<h2 id=\"ead_bio_display\">#{Blacklight.config[:ead_fields][:headings]["ead_bio_display"]}</h2>"

    xml = Rockhall::EadMethods.ead_xml(@document)
    element = xml.xpath(Blacklight.config[:ead_fields][:xpath]["ead_bio_display"])
    list   = element.xpath('chronlist')
    items  = list.xpath('chronitem')

    # Timeline table
    results << "<table>"
    items.each do |chronitem|
      results << "<tr><td>" + chronitem.xpath('date').first + "</td><td>"
      chronitem.xpath('.//event').each do |chronevent|
        results << chronevent.text + "<br/>"
      end
      results << "</td></tr>"
    end
    results << "</table>"

    # Paragraphs
    results << ead_paragraphs(element)

    # Sources
    results << "<h3>Sources</h3>"
    element.xpath("./list/item").each do |source|
      results << "<p>#{source.text}</p>"
    end

    return results.html_safe
  end


  def comma_list(args)
    fields = Array.new
    args.each do |text|
      unless text.nil?
        fields << text
      end
    end
    return fields.join(", ")
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
      unless Blacklight.config[:ead_fields][:headings][f.to_s].nil? or @document[f.to_s].nil?
        results << "<li>"
        results << link_to(Blacklight.config[:ead_fields][:headings][f.to_s], catalog_path(@document["ead_id"], :anchor => f))
        results << "</li>"
      end
    end
    return results.html_safe
  end

end